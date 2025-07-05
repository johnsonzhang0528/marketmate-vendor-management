# 創市通 MarketMate - VSCode GitHub Copilot 指導說明

## 專案概述
您正在協助開發「創市通 MarketMate」，這是一個專為文創市集攤販設計的管理系統。

### 專案資訊
- **產品名稱**：創市通 (MarketMate)
- **目標用戶**：文創市集攤販
- **技術架構**：全端 TypeScript + Git Worktree 並行開發
- **開發模式**：模組化開發，每個功能使用獨立的 worktree
- **IDE 環境**：VSCode + GitHub Copilot + Claude Code

### Git Worktree 架構
```
vendor-management-system/
├── .vscode/                 # VSCode 配置文件
├── config/                  # 共用配置
├── docs/                    # 專案文檔
├── scripts/                 # 自動化腳本
└── worktrees/               # Git Worktree 目錄
    ├── frontend/            # React + TypeScript + Vite
    ├── backend/             # Node.js + Express + Prisma
    ├── inventory/           # 庫存管理模組
    ├── pos/                 # POS 系統模組
    ├── customer/            # 客戶管理模組
    ├── analytics/           # 財務分析模組
    ├── mobile/              # PWA/React Native
    └── docs/                # VitePress 技術文件
```

### 核心功能模組
1. **庫存管理** (inventory) - 商品管理、庫存追蹤、預警系統
2. **POS系統** (pos) - 銷售、結帳、收據列印
3. **客戶管理** (customer) - 會員資料、購買歷史、忠誠度計劃
4. **財務分析** (analytics) - 銷售報表、利潤分析、趨勢預測
5. **前端介面** (frontend) - React + TypeScript + Tailwind CSS
6. **後端API** (backend) - Node.js + Express + Prisma + PostgreSQL
7. **行動應用** (mobile) - PWA/React Native
8. **專案文件** (docs) - VitePress 技術文件

## VSCode 開發環境指導

### 工作區結構
- 使用 `.code-workspace` 文件管理多個 worktree
- 每個模組獨立配置 ESLint、Prettier、TypeScript
- 共用 VSCode 設定存放在主專案 `.vscode/` 目錄

### 開發流程
1. 使用 `Ctrl+Shift+P` 開啟命令面板
2. 選擇 `Tasks: Run Task` 執行預定義任務
3. 使用 `F5` 啟動對應模組的除錯器
4. 利用 `Ctrl+`` 開啟整合終端機

## 代碼生成指導原則

### TypeScript 優先
- 所有新代碼必須使用 TypeScript
- 定義清晰的接口和類型
- 使用泛型提高代碼重用性
- 啟用嚴格模式 (`strict: true`)

### 命名規範
```typescript
// 接口命名：I + PascalCase
interface IProduct {
  id: string;
  name: string;
  price: number;
}

interface IInventoryRecord {
  productId: string;
  quantity: number;
  lastUpdated: Date;
}

// 類型命名：T + PascalCase
type TApiResponse<T> = {
  success: boolean;
  data?: T;
  error?: string;
  timestamp: string;
}

type TOrderStatus = 'PENDING' | 'PROCESSING' | 'COMPLETED' | 'CANCELLED';

// 組件命名：PascalCase
const ProductCard: React.FC<IProductCardProps> = ({ product }) => {
  return <div className="product-card">{product.name}</div>;
};

// 變數命名：camelCase
const productList: IProduct[] = [];
const isLoading = false;
const userAuthToken = '';

// 常數命名：SCREAMING_SNAKE_CASE
const MAX_PRODUCTS_PER_PAGE = 20;
const API_ENDPOINTS = {
  PRODUCTS: '/api/products',
  ORDERS: '/api/orders',
} as const;

// 檔案命名：kebab-case
// product-card.tsx, inventory-service.ts, user-profile.component.tsx
```

### 資料結構範本
```typescript
// 通用實體接口
interface IBaseEntity {
  id: string;
  createdAt: Date;
  updatedAt: Date;
  createdBy?: string;
  isActive: boolean;
}

// API 響應格式
interface IApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  timestamp: string;
  requestId?: string;
}

// 分頁資料
interface IPaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
}

// 錯誤處理
interface IErrorResponse {
  error: string;
  message: string;
  statusCode: number;
  timestamp: string;
  path?: string;
  details?: Record<string, any>;
}
```

### React 組件模式
```typescript
// 組件 Props 接口
interface IProductCardProps {
  // 必需屬性
  product: IProduct;
  onSelect: (product: IProduct) => void;

  // 可選屬性
  className?: string;
  variant?: 'default' | 'compact' | 'detailed';
  showActions?: boolean;

  // 事件處理
  onEdit?: (product: IProduct) => void;
  onDelete?: (productId: string) => void;

  // 子元素
  children?: React.ReactNode;
}

// 函數組件範本
const ProductCard: React.FC<IProductCardProps> = ({
  product,
  onSelect,
  className = '',
  variant = 'default',
  showActions = true,
  onEdit,
  onDelete,
  children
}) => {
  // 狀態管理
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // 自訂 Hook
  const { formatCurrency } = useFormat();

  // 副作用
  useEffect(() => {
    // 組件掛載後的邏輯
    return () => {
      // 清理函數
    };
  }, [product.id]);

  // 事件處理
  const handleSelect = useCallback(() => {
    if (!isLoading) {
      onSelect(product);
    }
  }, [product, onSelect, isLoading]);

  const handleEdit = useCallback(() => {
    if (onEdit) {
      onEdit(product);
    }
  }, [product, onEdit]);

  // 條件渲染
  if (error) {
    return (
      <div className="error-card">
        <p>錯誤：{error}</p>
      </div>
    );
  }

  return (
    <div
      className={`product-card product-card--${variant} ${className}`}
      onClick={handleSelect}
      role="button"
      tabIndex={0}
      aria-label={`選擇商品 ${product.name}`}
    >
      <div className="product-card__content">
        <h3 className="product-card__title">{product.name}</h3>
        <p className="product-card__price">
          {formatCurrency(product.price)}
        </p>

        {showActions && (
          <div className="product-card__actions">
            <button
              onClick={(e) => {
                e.stopPropagation();
                handleEdit();
              }}
              className="btn btn--sm btn--secondary"
              aria-label="編輯商品"
            >
              編輯
            </button>

            {onDelete && (
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  if (window.confirm('確定要刪除此商品嗎？')) {
                    onDelete(product.id);
                  }
                }}
                className="btn btn--sm btn--danger"
                aria-label="刪除商品"
              >
                刪除
              </button>
            )}
          </div>
        )}
      </div>

      {children}
    </div>
  );
};

// 組件導出
export default ProductCard;
```

### 服務層模式
```typescript
// API 服務基類
abstract class BaseApiService {
  protected baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  protected async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<IApiResponse<T>> {
    try {
      const response = await fetch(`${this.baseUrl}${endpoint}`, {
        headers: {
          'Content-Type': 'application/json',
          ...options.headers,
        },
        ...options,
      });

      if (!response.ok) {
        throw new ApiError(response.status, `HTTP ${response.status}`);
      }

      return await response.json();
    } catch (error) {
      if (error instanceof ApiError) {
        throw error;
      }
      throw new ApiError(500, '網路請求失敗');
    }
  }
}

// 具體服務實現
class ProductService extends BaseApiService {
  constructor() {
    super('/api/products');
  }

  async getProducts(params?: {
    page?: number;
    pageSize?: number;
    search?: string;
    category?: string;
  }): Promise<IPaginatedResponse<IProduct>> {
    const searchParams = new URLSearchParams();

    if (params?.page) searchParams.set('page', params.page.toString());
    if (params?.pageSize) searchParams.set('pageSize', params.pageSize.toString());
    if (params?.search) searchParams.set('search', params.search);
    if (params?.category) searchParams.set('category', params.category);

    const queryString = searchParams.toString();
    const endpoint = queryString ? `?${queryString}` : '';

    const response = await this.request<IPaginatedResponse<IProduct>>(endpoint);
    return response.data!;
  }

  async getProductById(id: string): Promise<IProduct> {
    const response = await this.request<IProduct>(`/${id}`);
    return response.data!;
  }

  async createProduct(data: Omit<IProduct, 'id' | 'createdAt' | 'updatedAt'>): Promise<IProduct> {
    const response = await this.request<IProduct>('', {
      method: 'POST',
      body: JSON.stringify(data),
    });
    return response.data!;
  }

  async updateProduct(id: string, data: Partial<IProduct>): Promise<IProduct> {
    const response = await this.request<IProduct>(`/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
    return response.data!;
  }

  async deleteProduct(id: string): Promise<void> {
    await this.request(`/${id}`, { method: 'DELETE' });
  }
}

// 錯誤處理
class ApiError extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public details?: Record<string, any>
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

// 服務實例
export const productService = new ProductService();
```

### 資料庫模式 (Prisma)
```prisma
// 基本模型結構
model Product {
  id          String   @id @default(cuid())
  name        String   @db.VarChar(100)
  description String?  @db.Text
  price       Decimal  @db.Decimal(10, 2)
  cost        Decimal  @db.Decimal(10, 2)
  sku         String   @unique @db.VarChar(50)
  barcode     String?  @db.VarChar(50)

  // 狀態欄位
  isActive    Boolean  @default(true)
  isDeleted   Boolean  @default(false)

  // 時間戳記
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  // 關聯
  category    Category @relation(fields: [categoryId], references: [id])
  categoryId  String

  // 庫存記錄
  inventory   InventoryRecord[]

  // 訂單項目
  orderItems  OrderItem[]

  @@map("products")
  @@index([categoryId])
  @@index([isActive, isDeleted])
}

model Category {
  id        String    @id @default(cuid())
  name      String    @db.VarChar(50)
  color     String?   @db.VarChar(7) // HEX color
  icon      String?   @db.VarChar(50)
  isActive  Boolean   @default(true)
  createdAt DateTime  @default(now())
  updatedAt DateTime  @updatedAt

  products  Product[]

  @@map("categories")
}
```

## 特定模組指導

### 庫存管理 (Inventory)
- **重點**：庫存追蹤準確性、批次管理、預警機制
- **關鍵實體**：Product, InventoryRecord, StockLevel, BatchInfo
- **特殊需求**：支援條碼掃描、多單位轉換、庫存預警
- **VSCode 配置**：啟用條碼掃描除錯器、庫存監控面板

### POS系統 (POS)
- **重點**：快速結帳、離線支援、硬體整合
- **關鍵實體**：Order, OrderItem, Payment, Receipt
- **特殊需求**：觸控友好介面、大按鈕設計、收銀機整合
- **VSCode 配置**：觸控裝置模擬器、POS 硬體除錯

### 客戶管理 (Customer)
- **重點**：會員制度、購買歷史、隱私保護
- **關鍵實體**：Customer, Interaction, LoyaltyProgram, Purchase
- **特殊需求**：GDPR 合規、資料加密、個人化推薦
- **VSCode 配置**：隱私合規檢查、資料加密工具

### 財務分析 (Analytics)
- **重點**：報表準確性、視覺化、效能優化
- **關鍵實體**：SalesReport, ProfitAnalysis, Trend, Forecast
- **特殊需求**：圖表庫整合、大數據處理、即時分析
- **VSCode 配置**：效能監控、記憶體使用分析

## 代碼品質要求

### 錯誤處理
```typescript
// 統一錯誤處理模式
interface IErrorHandler {
  handleError(error: Error, context?: Record<string, any>): void;
  logError(error: Error, context?: Record<string, any>): void;
}

class ErrorHandler implements IErrorHandler {
  handleError(error: Error, context: Record<string, any> = {}): void {
    console.error('Error occurred:', {
      message: error.message,
      stack: error.stack,
      context,
      timestamp: new Date().toISOString(),
    });

    // 發送錯誤到監控系統
    this.sendToMonitoring(error, context);
  }

  logError(error: Error, context: Record<string, any> = {}): void {
    // 記錄到日誌系統
    console.log('Error logged:', {
      message: error.message,
      context,
      timestamp: new Date().toISOString(),
    });
  }

  private sendToMonitoring(error: Error, context: Record<string, any>): void {
    // 實現監控系統整合
  }
}

// 在組件中使用
const handleApiCall = async (): Promise<IApiResponse<any>> => {
  try {
    const result = await apiService.getData();
    return { success: true, data: result };
  } catch (error) {
    errorHandler.handleError(error as Error, {
      component: 'ProductList',
      action: 'fetchProducts'
    });
    return { success: false, error: (error as Error).message };
  }
};
```

### 測試要求
```typescript
// 單元測試範例
describe('ProductService', () => {
  let productService: ProductService;

  beforeEach(() => {
    productService = new ProductService();
  });

  it('should fetch products successfully', async () => {
    const mockProducts = [
      { id: '1', name: 'Product 1', price: 100 },
      { id: '2', name: 'Product 2', price: 200 },
    ];

    // Mock API response
    jest.spyOn(global, 'fetch').mockResolvedValue({
      ok: true,
      json: async () => ({ success: true, data: mockProducts }),
    } as Response);

    const result = await productService.getProducts();

    expect(result).toEqual(mockProducts);
    expect(global.fetch).toHaveBeenCalledWith('/api/products');
  });

  it('should handle API errors', async () => {
    jest.spyOn(global, 'fetch').mockRejectedValue(new Error('Network error'));

    await expect(productService.getProducts()).rejects.toThrow('Network error');
  });
});

// 整合測試
describe('Product Management Integration', () => {
  it('should create and retrieve product', async () => {
    const newProduct = {
      name: 'Test Product',
      price: 99.99,
      category: 'Electronics',
    };

    // 建立商品
    const created = await productService.createProduct(newProduct);
    expect(created.id).toBeDefined();
    expect(created.name).toBe(newProduct.name);

    // 取得商品
    const retrieved = await productService.getProductById(created.id);
    expect(retrieved).toEqual(created);
  });
});
```

### 效能考量
```typescript
// React 效能優化
const ProductList = memo<IProductListProps>(({ products, onProductSelect }) => {
  // 使用 useMemo 優化重複計算
  const filteredProducts = useMemo(() => {
    return products.filter(product => product.isActive);
  }, [products]);

  // 使用 useCallback 優化函數引用
  const handleProductSelect = useCallback((product: IProduct) => {
    onProductSelect(product);
  }, [onProductSelect]);

  return (
    <div className="product-list">
      {filteredProducts.map(product => (
        <ProductCard
          key={product.id}
          product={product}
          onSelect={handleProductSelect}
        />
      ))}
    </div>
  );
});

// 虛擬化長列表
import { FixedSizeList as List } from 'react-window';

const VirtualizedProductList: React.FC<IProductListProps> = ({ products }) => {
  const Row = ({ index, style }: { index: number; style: React.CSSProperties }) => (
    <div style={style}>
      <ProductCard product={products[index]} />
    </div>
  );

  return (
    <List
      height={600}
      itemCount={products.length}
      itemSize={120}
      width="100%"
    >
      {Row}
    </List>
  );
};
```

### 安全性
```typescript
// 輸入驗證
import { z } from 'zod';

const ProductSchema = z.object({
  name: z.string().min(1, '商品名稱不能為空').max(100, '商品名稱過長'),
  price: z.number().positive('價格必須大於零').max(999999, '價格過高'),
  description: z.string().optional(),
  categoryId: z.string().uuid('無效的分類ID'),
});

// 在 API 端點中使用
app.post('/api/products', async (req, res) => {
  try {
    const validatedData = ProductSchema.parse(req.body);
    const product = await productService.createProduct(validatedData);
    res.json({ success: true, data: product });
  } catch (error) {
    if (error instanceof z.ZodError) {
      res.status(400).json({
        success: false,
        error: '輸入資料無效',
        details: error.errors
      });
    } else {
      res.status(500).json({ success: false, error: '伺服器錯誤' });
    }
  }
});

// JWT 認證
const authenticateToken = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: '存取權杖遺失' });
  }

  jwt.verify(token, process.env.JWT_SECRET!, (err, user) => {
    if (err) {
      return res.status(403).json({ error: '無效的存取權杖' });
    }
    req.user = user;
    next();
  });
};
```

## VSCode 專屬開發流程

### 1. 專案啟動
```bash
# 使用 VSCode 命令面板
Ctrl+Shift+P > Tasks: Run Task > 🚀 Setup: Initialize All Worktrees
```

### 2. 並行開發
```bash
# 同時開發多個模組
Ctrl+Shift+P > Tasks: Run Task > 🚀 Start Full Development Environment
```

### 3. 除錯模式
```bash
# 啟動除錯器
F5 > 選擇對應的除錯配置
```

### 4. 測試執行
```bash
# 執行完整測試套件
Ctrl+Shift+P > Tasks: Run Task > 🧪 Run Complete Test Suite
```

### 5. 代碼品質檢查
```bash
# 執行 Lint 和格式化
Ctrl+Shift+P > Tasks: Run Task > 🔍 Lint: Fix All
```

## 與 Claude Code 整合指導

### 提示詞範本
當與 Claude Code 協作時，請提供以下上下文：

```
## 當前開發環境
- 專案：創市通 MarketMate
- 模組：[指定模組名稱]
- 技術棧：TypeScript + React + Node.js
- 開發模式：Git Worktree 並行開發

## 請求類型
- [ ] 新功能開發
- [ ] Bug 修復
- [ ] 代碼重構
- [ ] 效能優化
- [ ] 測試撰寫

## 具體需求
[詳細描述您的需求]

## 相關文件
- 資料庫結構：[Prisma Schema]
- API 端點：[相關 API 文檔]
- 組件結構：[React 組件樹]
```

遵循這些指導原則，確保代碼品質和專案一致性。所有生成的代碼都應該適用於 VSCode 開發環境並支援 Git Worktree 工作流程。
