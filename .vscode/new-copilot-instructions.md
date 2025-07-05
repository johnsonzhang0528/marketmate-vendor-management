# 創市通 MarketMate - 進階 VSCode 開發指導 (2025)

## 最新技術棧整合

### 現代化開發工具鏈
- **前端**：React 18 + TypeScript 5 + Vite 5 + Tailwind CSS 4
- **後端**：Node.js 20 + Express + Prisma 5 + PostgreSQL 16
- **狀態管理**：Zustand 4 (輕量級，取代 Redux)
- **數據請求**：TanStack Query v5 (取代 React Query)
- **表單處理**：React Hook Form + Zod 3 驗證
- **測試框架**：Vitest (取代 Jest) + Testing Library
- **構建工具**：Vite 5 (取代 Webpack)
- **部署平台**：Vercel/Netlify + Docker

### VSCode 擴展建議
```json
{
  "recommendations": [
    "ms-vscode.vscode-typescript-next",
    "bradlc.vscode-tailwindcss",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "GitHub.copilot",
    "GitHub.copilot-chat",
    "GitHub.copilot-labs",
    "ms-playwright.playwright",
    "vitest.explorer",
    "Prisma.prisma",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-thunder-client",
    "formulahendry.auto-rename-tag",
    "christian-kohler.path-intellisense",
    "ms-vscode.vscode-json"
  ]
}
```

## 現代化開發模式

### 1. 組件驅動開發 (Component-Driven Development)
```typescript
// 使用 Storybook 進行組件文檔化
import type { Meta, StoryObj } from '@storybook/react';
import { ProductCard } from './ProductCard';

const meta: Meta<typeof ProductCard> = {
  title: 'Components/ProductCard',
  component: ProductCard,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: { type: 'select' },
      options: ['default', 'compact', 'detailed'],
    },
  },
};

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    product: {
      id: '1',
      name: '手工皮革錢包',
      price: 1200,
      imageUrl: '/images/wallet.jpg',
      category: '皮革製品',
    },
  },
};

export const Compact: Story = {
  args: {
    ...Default.args,
    variant: 'compact',
  },
};
```

### 2. 現代化 React Hooks 模式
```typescript
// 使用 TanStack Query v5
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { productService } from '@/services/product-service';

// 產品查詢 Hook
export const useProducts = (params?: IProductQueryParams) => {
  return useQuery({
    queryKey: ['products', params],
    queryFn: () => productService.getProducts(params),
    staleTime: 5 * 60 * 1000, // 5 分鐘
    gcTime: 10 * 60 * 1000, // 10 分鐘 (舊版 cacheTime)
    retry: 3,
    retryDelay: attemptIndex => Math.min(1000 * 2 ** attemptIndex, 30000),
  });
};

// 產品新增 Hook
export const useCreateProduct = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: productService.createProduct,
    onSuccess: (newProduct) => {
      // 更新快取
      queryClient.setQueryData(['products'], (old: IProduct[] | undefined) => {
        return old ? [...old, newProduct] : [newProduct];
      });

      // 重新取得產品列表
      queryClient.invalidateQueries({ queryKey: ['products'] });
    },
    onError: (error) => {
      console.error('創建產品失敗:', error);
    },
  });
};

// 使用 Zustand 進行狀態管理
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';

interface IAppState {
  // 狀態
  user: IUser | null;
  theme: 'light' | 'dark';
  sidebarOpen: boolean;

  // 動作
  setUser: (user: IUser | null) => void;
  toggleTheme: () => void;
  toggleSidebar: () => void;

  // 非同步動作
  login: (credentials: ILoginCredentials) => Promise<void>;
  logout: () => Promise<void>;
}

export const useAppStore = create<IAppState>()(
  devtools(
    persist(
      (set, get) => ({
        // 初始狀態
        user: null,
        theme: 'light',
        sidebarOpen: false,

        // 同步動作
        setUser: (user) => set({ user }),
        toggleTheme: () => set((state) => ({
          theme: state.theme === 'light' ? 'dark' : 'light'
        })),
        toggleSidebar: () => set((state) => ({
          sidebarOpen: !state.sidebarOpen
        })),

        // 非同步動作
        login: async (credentials) => {
          try {
            const user = await authService.login(credentials);
            set({ user });
          } catch (error) {
            console.error('登入失敗:', error);
            throw error;
          }
        },

        logout: async () => {
          try {
            await authService.logout();
            set({ user: null });
          } catch (error) {
            console.error('登出失敗:', error);
          }
        },
      }),
      {
        name: 'app-storage',
        partialize: (state) => ({
          user: state.user,
          theme: state.theme
        }),
      }
    )
  )
);
```

### 3. 表單處理最佳實踐
```typescript
// 使用 React Hook Form + Zod
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

// 表單驗證 Schema
const productFormSchema = z.object({
  name: z.string()
    .min(1, '商品名稱不能為空')
    .max(100, '商品名稱過長'),
  price: z.number()
    .positive('價格必須大於零')
    .max(999999, '價格過高'),
  description: z.string().optional(),
  categoryId: z.string().uuid('請選擇有效的分類'),
  tags: z.array(z.string()).max(10, '標籤數量不能超過10個'),
  images: z.array(z.instanceof(File)).max(5, '圖片數量不能超過5張'),
});

type TProductFormData = z.infer<typeof productFormSchema>;

// 產品表單組件
const ProductForm: React.FC<IProductFormProps> = ({
  initialData,
  onSubmit,
  onCancel
}) => {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    setValue,
    watch,
    reset,
  } = useForm<TProductFormData>({
    resolver: zodResolver(productFormSchema),
    defaultValues: initialData || {
      name: '',
      price: 0,
      description: '',
      categoryId: '',
      tags: [],
      images: [],
    },
  });

  const watchedPrice = watch('price');
  const createProductMutation = useCreateProduct();

  const onFormSubmit = async (data: TProductFormData) => {
    try {
      await createProductMutation.mutateAsync(data);
      toast.success('商品創建成功！');
      reset();
      onSubmit?.(data);
    } catch (error) {
      toast.error('創建商品時發生錯誤');
    }
  };

  return (
    <form onSubmit={handleSubmit(onFormSubmit)} className="space-y-6">
      <div>
        <label htmlFor="name" className="block text-sm font-medium text-gray-700">
          商品名稱 *
        </label>
        <input
          {...register('name')}
          type="text"
          id="name"
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          placeholder="請輸入商品名稱"
        />
        {errors.name && (
          <p className="mt-1 text-sm text-red-600">{errors.name.message}</p>
        )}
      </div>

      <div>
        <label htmlFor="price" className="block text-sm font-medium text-gray-700">
          價格 *
        </label>
        <div className="mt-1 relative rounded-md shadow-sm">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <span className="text-gray-500 sm:text-sm">NT$</span>
          </div>
          <input
            {...register('price', { valueAsNumber: true })}
            type="number"
            id="price"
            className="block w-full pl-12 pr-12 border-gray-300 rounded-md focus:ring-indigo-500 focus:border-indigo-500"
            placeholder="0"
          />
        </div>
        {errors.price && (
          <p className="mt-1 text-sm text-red-600">{errors.price.message}</p>
        )}
        {watchedPrice > 0 && (
          <p className="mt-1 text-sm text-gray-500">
            含稅價格：NT$ {Math.round(watchedPrice * 1.05)}
          </p>
        )}
      </div>

      <div className="flex justify-end space-x-4">
        <button
          type="button"
          onClick={onCancel}
          className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
        >
          取消
        </button>
        <button
          type="submit"
          disabled={isSubmitting}
          className="px-4 py-2 text-sm font-medium text-white bg-indigo-600 border border-transparent rounded-md hover:bg-indigo-700 disabled:opacity-50"
        >
          {isSubmitting ? '創建中...' : '創建商品'}
        </button>
      </div>
    </form>
  );
};
```

### 4. 現代化 API 設計
```typescript
// 使用 Hono 框架 (更現代的 Express 替代品)
import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { logger } from 'hono/logger';
import { zValidator } from '@hono/zod-validator';

const app = new Hono();

// 中間件
app.use('*', cors());
app.use('*', logger());

// 路由定義
app.get('/api/products',
  zValidator('query', z.object({
    page: z.string().optional().transform(Number),
    limit: z.string().optional().transform(Number),
    search: z.string().optional(),
  })),
  async (c) => {
    const { page = 1, limit = 10, search } = c.req.valid('query');

    try {
      const products = await productService.getProducts({
        page,
        limit,
        search,
      });

      return c.json({
        success: true,
        data: products,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      return c.json({
        success: false,
        error: error.message,
        timestamp: new Date().toISOString(),
      }, 500);
    }
  }
);

app.post('/api/products',
  zValidator('json', productFormSchema),
  async (c) => {
    const productData = c.req.valid('json');

    try {
      const newProduct = await productService.createProduct(productData);

      return c.json({
        success: true,
        data: newProduct,
        timestamp: new Date().toISOString(),
      }, 201);
    } catch (error) {
      return c.json({
        success: false,
        error: error.message,
        timestamp: new Date().toISOString(),
      }, 400);
    }
  }
);

// 類型安全的路由
type AppType = typeof app;
export type { AppType };
```

### 5. 現代化測試策略
```typescript
// 使用 Vitest 進行單元測試
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, userEvent } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ProductCard } from './ProductCard';

// 測試工具函數
const createTestQueryClient = () => {
  return new QueryClient({
    defaultOptions: {
      queries: { retry: false },
      mutations: { retry: false },
    },
  });
};

const renderWithQueryClient = (ui: React.ReactElement) => {
  const queryClient = createTestQueryClient();
  return render(
    <QueryClientProvider client={queryClient}>
      {ui}
    </QueryClientProvider>
  );
};

describe('ProductCard', () => {
  const mockProduct = {
    id: '1',
    name: 'Test Product',
    price: 100,
    category: 'Electronics',
    imageUrl: '/test-image.jpg',
  };

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('renders product information correctly', () => {
    renderWithQueryClient(
      <ProductCard product={mockProduct} />
    );

    expect(screen.getByText('Test Product')).toBeInTheDocument();
    expect(screen.getByText('NT$ 100')).toBeInTheDocument();
    expect(screen.getByText('Electronics')).toBeInTheDocument();
  });

  it('handles product selection', async () => {
    const mockOnSelect = vi.fn();
    const user = userEvent.setup();

    renderWithQueryClient(
      <ProductCard
        product={mockProduct}
        onSelect={mockOnSelect}
      />
    );

    const productCard = screen.getByRole('button');
    await user.click(productCard);

    expect(mockOnSelect).toHaveBeenCalledWith(mockProduct);
  });

  it('shows loading state when updating', async () => {
    const mockOnUpdate = vi.fn().mockImplementation(
      () => new Promise(resolve => setTimeout(resolve, 100))
    );

    renderWithQueryClient(
      <ProductCard
        product={mockProduct}
        onUpdate={mockOnUpdate}
      />
    );

    const updateButton = screen.getByText('更新');
    await userEvent.click(updateButton);

    expect(screen.getByText('更新中...')).toBeInTheDocument();
  });
});

// 整合測試
describe('Product Management Flow', () => {
  it('allows creating and viewing products', async () => {
    const user = userEvent.setup();

    renderWithQueryClient(<ProductManagementPage />);

    // 點擊新增按鈕
    const addButton = screen.getByText('新增商品');
    await user.click(addButton);

    // 填寫表單
    const nameInput = screen.getByLabelText('商品名稱');
    const priceInput = screen.getByLabelText('價格');

    await user.type(nameInput, 'New Product');
    await user.type(priceInput, '150');

    // 提交表單
    const submitButton = screen.getByText('創建商品');
    await user.click(submitButton);

    // 驗證結果
    expect(await screen.findByText('New Product')).toBeInTheDocument();
    expect(screen.getByText('NT$ 150')).toBeInTheDocument();
  });
});

// E2E 測試 (Playwright)
import { test, expect } from '@playwright/test';

test.describe('Product Management', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/products');
  });

  test('should create a new product', async ({ page }) => {
    await page.click('text=新增商品');

    await page.fill('[data-testid="product-name"]', 'E2E Test Product');
    await page.fill('[data-testid="product-price"]', '299');
    await page.selectOption('[data-testid="product-category"]', 'electronics');

    await page.click('text=創建商品');

    await expect(page.locator('text=E2E Test Product')).toBeVisible();
  });

  test('should filter products by category', async ({ page }) => {
    await page.selectOption('[data-testid="category-filter"]', 'electronics');

    const productCards = page.locator('[data-testid="product-card"]');
    await expect(productCards).toHaveCount(5);
  });
});
```

## VSCode 工作流程優化

### 1. 自動化開發任務
```json
{
  "tasks": [
    {
      "label": "🚀 Dev: Hot Reload All",
      "dependsOrder": "parallel",
      "dependsOn": [
        "Dev: Frontend (Vite)",
        "Dev: Backend (Nodemon)",
        "Dev: Storybook",
        "Dev: Test Watch"
      ],
      "group": "build",
      "presentation": {
        "reveal": "always",
        "panel": "dedicated"
      }
    },
    {
      "label": "🧪 Test: Coverage Report",
      "type": "shell",
      "command": "npm run test:coverage && npm run test:coverage:open",
      "group": "test",
      "presentation": {
        "reveal": "always",
        "panel": "dedicated"
      }
    },
    {
      "label": "📊 Analyze: Bundle Size",
      "type": "shell",
      "command": "npm run build:analyze",
      "options": {
        "cwd": "../worktrees/frontend"
      },
      "group": "build",
      "presentation": {
        "reveal": "always",
        "panel": "dedicated"
      }
    }
  ]
}
```

### 2. 智能代碼片段
```json
{
  "React Component with TypeScript": {
    "prefix": "rfc",
    "body": [
      "import React from 'react';",
      "",
      "interface I${1:ComponentName}Props {",
      "  $2",
      "}",
      "",
      "const ${1:ComponentName}: React.FC<I${1:ComponentName}Props> = ({",
      "  $3",
      "}) => {",
      "  return (",
      "    <div className=\"${4:component-name}\">",
      "      $5",
      "    </div>",
      "  );",
      "};",
      "",
      "export default ${1:ComponentName};"
    ],
    "description": "Create a React Function Component with TypeScript"
  },
  "Custom Hook": {
    "prefix": "hook",
    "body": [
      "import { useState, useEffect } from 'react';",
      "",
      "interface I${1:HookName}Return {",
      "  $2",
      "}",
      "",
      "export const use${1:HookName} = ($3): I${1:HookName}Return => {",
      "  const [state, setState] = useState($4);",
      "",
      "  useEffect(() => {",
      "    $5",
      "  }, [$6]);",
      "",
      "  return {",
      "    $7",
      "  };",
      "};"
    ],
    "description": "Create a custom React hook"
  }
}
```

### 3. 除錯配置優化
```json
{
  "configurations": [
    {
      "name": "🔍 Debug Frontend + Backend",
      "type": "compound",
      "configurations": [
        "Debug Frontend (Vite)",
        "Debug Backend (Node.js)",
        "Debug Tests (Vitest)"
      ],
      "presentation": {
        "group": "debug",
        "order": 1
      }
    },
    {
      "name": "🧪 Debug Tests with Coverage",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/node_modules/vitest/vitest.mjs",
      "args": ["run", "--coverage", "--reporter=verbose"],
      "console": "integratedTerminal",
      "env": {
        "NODE_ENV": "test"
      }
    }
  ]
}
```

## 效能監控和優化

### 1. 前端效能監控
```typescript
// 使用 Web Vitals 監控
import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals';

const sendToAnalytics = (metric: any) => {
  // 發送效能數據到分析服務
  console.log('Performance metric:', metric);
};

getCLS(sendToAnalytics);
getFID(sendToAnalytics);
getFCP(sendToAnalytics);
getLCP(sendToAnalytics);
getTTFB(sendToAnalytics);

// React 性能分析
import { Profiler } from 'react';

const ProfilerWrapper: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const onRenderCallback = (
    id: string,
    phase: 'mount' | 'update',
    actualDuration: number,
    baseDuration: number,
    startTime: number,
    commitTime: number
  ) => {
    console.log('Profiler data:', {
      id,
      phase,
      actualDuration,
      baseDuration,
      startTime,
      commitTime,
    });
  };

  return (
    <Profiler id="ProductList" onRender={onRenderCallback}>
      {children}
    </Profiler>
  );
};
```

### 2. 後端效能監控
```typescript
// 使用 pino 進行日誌記錄
import pino from 'pino';

const logger = pino({
  transport: {
    target: 'pino-pretty',
    options: {
      colorize: true,
    },
  },
});

// 效能中間件
const performanceMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = Date.now() - start;
    logger.info({
      method: req.method,
      url: req.url,
      statusCode: res.statusCode,
      duration,
    }, 'Request completed');
  });

  next();
};
```

## 與 Claude Code 協作最佳實踐

### 1. 結構化提示詞範本
```markdown
## 🎯 開發任務
**模組**: [frontend/backend/inventory/pos/customer/analytics]
**功能**: [具體功能描述]
**優先級**: [高/中/低]

## 📋 技術需求
- [ ] TypeScript 5 嚴格模式
- [ ] React 18 並發特性
- [ ] Tailwind CSS 4 組件
- [ ] Vitest 測試覆蓋
- [ ] ESLint/Prettier 格式化

## 🔧 VSCode 整合
- 工作區配置: `vendor-management.code-workspace`
- 除錯配置: 使用 F5 啟動對應模組
- 任務執行: `Ctrl+Shift+P > Tasks: Run Task`

## 📁 相關文件
- 資料庫: `../worktrees/backend/prisma/schema.prisma`
- 類型定義: `../worktrees/shared/types/`
- 組件庫: `../worktrees/frontend/src/components/`

## 🎨 設計要求
- 響應式設計 (mobile-first)
- 無障礙標準 (WCAG 2.1)
- 暗色主題支援
- 載入和錯誤狀態
```

### 2. 程式碼審查清單
```typescript
// 在提交代碼前，確保遵循以下檢查清單：

interface ICodeReviewChecklist {
  // TypeScript 類型安全
  hasProperTypes: boolean;
  usesStrictMode: boolean;

  // 效能優化
  usesMemoization: boolean;
  avoidsPropDrilling: boolean;

  // 可訪問性
  hasAriaLabels: boolean;
  supportsKeyboardNavigation: boolean;

  // 測試覆蓋
  hasUnitTests: boolean;
  hasIntegrationTests: boolean;

  // 代碼品質
  passesLinting: boolean;
  hasProperErrorHandling: boolean;

  // 文檔
  hasJSDocComments: boolean;
  hasStorybook: boolean;
}
```

這個進階指導文件涵蓋了現代化的開發模式、最新的技術棧，以及與 VSCode 的深度整合。它特別針對 Git Worktree 並行開發模式進行了優化，並提供了與 Claude Code 協作的最佳實踐。
