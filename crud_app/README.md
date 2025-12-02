# 📱 Flutter CRUD App

Aplikasi Flutter yang mendemonstrasikan implementasi **CRUD (Create, Read, Update, Delete)** dengan **2 metode penyimpanan** (Database & API) dan **2 pendekatan UI** (Multi Page & Single Page) yang berbeda.

## 🎯 Tujuan Pembelajaran

Project ini dibuat untuk memahami:
- ✅ **CRUD Operations** - Create, Read, Update, Delete
- ✅ **Local Database** - SQLite dengan sqflite package
- ✅ **REST API Integration** - HTTP requests dengan http package
- ✅ **State Management** - StatefulWidget dengan setState()
- ✅ **Form Handling** - Validation dan user input
- ✅ **Navigation Patterns** - Multi page vs Single page
- ✅ **Error Handling** - Try-catch dan user feedback

## 📋 Fitur Utama

### 4 Implementasi CRUD:

#### 1. 🗄️ Database CRUD - Multi Page
**Storage:** SQLite (Local Database)  
**UI Pattern:** Full screen form dengan navigasi

**Fitur:**
- ✅ Form lengkap dengan 6 fields (title, description, date, category, priority, image)
- ✅ Date picker untuk memilih tanggal
- ✅ Dropdown untuk category selection
- ✅ Radio buttons untuk priority level
- ✅ Form validation lengkap
- ✅ Navigate ke halaman terpisah untuk add/edit
- ✅ Data tersimpan permanent di device

**Use Case:** Form kompleks dengan banyak input, data penting yang perlu offline access

#### 2. 📋 Database CRUD - Single Page
**Storage:** SQLite (Local Database)  
**UI Pattern:** Dialog form tanpa navigasi

**Fitur:**
- ✅ Form sederhana dengan 2 fields (title, description)
- ✅ Dialog popup untuk quick input
- ✅ Validation basic
- ✅ Semua operasi di satu halaman
- ✅ Data tersimpan permanent di device

**Use Case:** Quick entry, data sederhana, minimal navigation

#### 3. ☁️ API CRUD - Multi Page
**Storage:** REST API (JSONPlaceholder)  
**UI Pattern:** Full screen form dengan navigasi

**Fitur:**
- ✅ Form lengkap dengan multiple fields
- ✅ HTTP requests (GET, POST, PUT, DELETE)
- ✅ Loading indicators untuk async operations
- ✅ Error handling dengan retry option
- ✅ Navigate ke halaman terpisah untuk add/edit
- ✅ Data sync dengan server

**Use Case:** Data yang perlu sync dengan server, collaborative apps

#### 4. 🌐 API CRUD - Single Page
**Storage:** REST API (JSONPlaceholder)  
**UI Pattern:** Dialog form tanpa navigasi

**Fitur:**
- ✅ Form sederhana dalam dialog
- ✅ HTTP requests dengan error handling
- ✅ Loading states
- ✅ Semua operasi di satu halaman
- ✅ Data sync dengan server

**Use Case:** Quick updates, simple data, minimal UI complexity

## 🏗️ Struktur Project

```
lib/
├── main.dart                           # Entry point aplikasi
├── models/
│   └── item_model.dart                 # Model data dengan serialisasi
├── services/
│   ├── database_service.dart           # Service untuk SQLite CRUD
│   └── api_service.dart                # Service untuk REST API CRUD
├── screens/
│   ├── home_screen.dart                # Home dengan 4 pilihan
│   ├── database_crud_multipage.dart    # Database list (multi page)
│   ├── database_form_screen.dart       # Database full form
│   ├── database_crud_singlepage.dart   # Database list (single page)
│   ├── api_crud_multipage.dart         # API list (multi page)
│   ├── api_form_screen.dart            # API full form
│   └── api_crud_singlepage.dart        # API list (single page)
└── widgets/
    ├── item_card.dart                  # Card untuk menampilkan item
    ├── simple_form_dialog.dart         # Dialog form sederhana
    └── delete_confirmation_dialog.dart # Dialog konfirmasi delete
```

## 🚀 Quick Start

### Prerequisites
- **Flutter SDK**: 3.9.0 atau lebih tinggi
- **Dart SDK**: 3.9.0 atau lebih tinggi
- **IDE**: Android Studio / VS Code dengan Flutter extension
- **Device**: Emulator atau physical device
- **Internet**: Diperlukan untuk API CRUD demo

### Instalasi

1. **Clone repository**
```bash
git clone https://github.com/rendramhardika/flutter-mobile-programming-class.git
cd flutter-mobile-programming-class/crud_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Jalankan aplikasi**
```bash
flutter run
```

4. **Pilih demo** dari home screen dan mulai explore!

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # Database
  sqflite: ^2.3.0          # SQLite database untuk local storage
  path_provider: ^2.1.1    # Get path untuk database file
  
  # HTTP Client
  http: ^1.1.0             # HTTP client untuk REST API calls
  
  # Utilities
  intl: ^0.19.0            # Date formatting dan internationalization
```

**Package Details:**
- **sqflite**: Local SQL database, persistent storage di device
- **path_provider**: Find correct path untuk menyimpan database file
- **http**: Make HTTP requests ke REST API
- **intl**: Format tanggal dan waktu dengan berbagai locale

## 🎯 Perbandingan Pendekatan

### Multi Page vs Single Page

| Aspek | Multi Page 📄 | Single Page 📋 |
|-------|--------------|----------------|
| **Form Location** | Separate screen | Dialog popup |
| **Navigation** | `Navigator.push()` | `showDialog()` |
| **Form Fields** | 6+ fields (comprehensive) | 2-3 fields (essential) |
| **Screen Space** | Full screen available | Limited to dialog size |
| **User Flow** | Navigate → Fill → Save → Back | Click → Fill → Save (stay) |
| **Validation** | Comprehensive with multiple rules | Basic validation |
| **UX** | Better for complex forms | Better for quick input |
| **Use Case** | Detailed data entry | Quick updates |
| **Example** | Registration form, Product details | Quick note, Simple task |

**Kapan Menggunakan Multi Page?**
- ✅ Form dengan banyak fields (>5)
- ✅ Perlu date picker, image picker, atau complex widgets
- ✅ User perlu fokus penuh pada form
- ✅ Validation rules yang kompleks

**Kapan Menggunakan Single Page?**
- ✅ Form sederhana (2-3 fields)
- ✅ Quick entry atau quick edit
- ✅ User perlu melihat list saat input
- ✅ Minimal context switching

### Database vs API

| Aspek | Database (SQLite) 🗄️ | API (REST) ☁️ |
|-------|---------------------|---------------|
| **Storage Location** | Local device | Remote server |
| **Offline Support** | ✅ Full offline | ❌ Requires internet |
| **Speed** | ⚡ Instant (local) | 🌐 Network dependent |
| **Data Persistence** | Permanent on device | Server dependent |
| **Data Sync** | Manual sync needed | Auto sync |
| **Storage Limit** | Device storage | Server capacity |
| **Multi-device** | ❌ Single device only | ✅ Accessible from any device |
| **Data Backup** | Manual backup | Server backup |
| **Collaboration** | ❌ Not possible | ✅ Real-time collaboration |
| **Cost** | Free (local) | May require server costs |

**Kapan Menggunakan Database?**
- ✅ App perlu offline functionality
- ✅ Data bersifat private/personal
- ✅ Perlu akses data yang sangat cepat
- ✅ Tidak perlu sync antar device
- ✅ Examples: Notes app, To-do list, Settings

**Kapan Menggunakan API?**
- ✅ Data perlu sync antar devices
- ✅ Collaborative features
- ✅ Real-time updates
- ✅ Data sharing dengan users lain
- ✅ Examples: Social media, Chat app, E-commerce

## 💡 Konsep & Implementasi

### 1. State Management

**Approach:** StatefulWidget dengan setState()

```dart
class DatabaseCrudMultiPage extends StatefulWidget {
  @override
  State<DatabaseCrudMultiPage> createState() => _DatabaseCrudMultiPageState();
}

class _DatabaseCrudMultiPageState extends State<DatabaseCrudMultiPage> {
  List<ItemModel> _items = [];
  bool _isLoading = false;
  
  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    try {
      final items = await DatabaseService.instance.readAll();
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError(e.toString());
    }
  }
}
```

**Keuntungan:**
- ✅ Sederhana dan mudah dipahami
- ✅ Tidak perlu library tambahan
- ✅ Cocok untuk app kecil-menengah
- ✅ Setiap screen manage state sendiri

### 2. Database Operations (SQLite)

**Service Pattern:**

```dart
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  
  // Singleton pattern
  DatabaseService._init();
  
  // CREATE
  Future<ItemModel> create(ItemModel item) async {
    final db = await database;
    final id = await db.insert('items', item.toMap());
    return item.copyWith(id: id);
  }
  
  // READ
  Future<List<ItemModel>> readAll() async {
    final db = await database;
    final result = await db.query('items', orderBy: 'createdAt DESC');
    return result.map((map) => ItemModel.fromMap(map)).toList();
  }
  
  // UPDATE
  Future<int> update(ItemModel item) async {
    final db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
  
  // DELETE
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

**Database Schema:**
```sql
CREATE TABLE items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  category TEXT,
  priority TEXT
)
```

### 3. API Operations (REST)

**Service Pattern:**

```dart
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String endpoint = '/posts';
  
  // CREATE
  Future<ItemModel> create(ItemModel item) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    
    if (response.statusCode == 201) {
      return ItemModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create');
  }
  
  // READ
  Future<List<ItemModel>> readAll() async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => ItemModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load');
  }
  
  // UPDATE
  Future<ItemModel> update(ItemModel item) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    
    if (response.statusCode == 200) {
      return ItemModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update');
  }
  
  // DELETE
  Future<void> delete(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint/$id'),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete');
    }
  }
}
```

**API Endpoint:** [JSONPlaceholder](https://jsonplaceholder.typicode.com)
- Free fake REST API untuk testing
- Endpoint: `/posts`
- Methods: GET, POST, PUT, DELETE
- Note: Data tidak benar-benar tersimpan (fake API)

### 4. Form Handling

**Multi Page Form:**
```dart
class DatabaseFormScreen extends StatefulWidget {
  final ItemModel? item; // null untuk create, ada value untuk edit
  
  @override
  State<DatabaseFormScreen> createState() => _DatabaseFormScreenState();
}

class _DatabaseFormScreenState extends State<DatabaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  String _selectedPriority = 'Medium';
  
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      // Load existing data untuk edit
      _titleController.text = widget.item!.title;
      _descriptionController.text = widget.item!.description;
      _selectedDate = widget.item!.createdAt;
      _selectedCategory = widget.item!.category;
      _selectedPriority = widget.item!.priority ?? 'Medium';
    }
  }
  
  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final item = ItemModel(
        id: widget.item?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: _selectedDate,
        category: _selectedCategory,
        priority: _selectedPriority,
      );
      
      if (widget.item == null) {
        await DatabaseService.instance.create(item);
      } else {
        await DatabaseService.instance.update(item);
      }
      
      Navigator.pop(context, true); // Return true untuk refresh list
    }
  }
}
```

**Single Page Dialog:**
```dart
Future<void> _showFormDialog({ItemModel? item}) async {
  final titleController = TextEditingController(text: item?.title);
  final descController = TextEditingController(text: item?.description);
  
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(item == null ? 'Add Item' : 'Edit Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: descController,
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            // Save logic
            Navigator.pop(context, true);
          },
          child: Text('Save'),
        ),
      ],
    ),
  );
  
  if (result == true) {
    _loadItems(); // Refresh list
  }
}
```

### 5. Error Handling

**Pattern:**
```dart
Future<void> _loadItems() async {
  setState(() => _isLoading = true);
  
  try {
    final items = await DatabaseService.instance.readAll();
    setState(() {
      _items = items;
      _isLoading = false;
      _error = null;
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
      _error = e.toString();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${e.toString()}'),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _loadItems,
        ),
      ),
    );
  }
}
```

### 6. UI/UX Features

**Loading State:**
```dart
if (_isLoading)
  Center(child: CircularProgressIndicator())
```

**Empty State:**
```dart
if (_items.isEmpty)
  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text('No items yet', style: TextStyle(color: Colors.grey)),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: _addItem,
          child: Text('Add First Item'),
        ),
      ],
    ),
  )
```

**Error State:**
```dart
if (_error != null)
  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: Colors.red),
        SizedBox(height: 16),
        Text('Error: $_error'),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: _loadItems,
          child: Text('Retry'),
        ),
      ],
    ),
  )
```

**Pull to Refresh:**
```dart
RefreshIndicator(
  onRefresh: _loadItems,
  child: ListView.builder(...),
)
```

**Delete Confirmation:**
```dart
Future<void> _deleteItem(ItemModel item) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete Item'),
      content: Text('Are you sure you want to delete "${item.title}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text('Delete'),
        ),
      ],
    ),
  );
  
  if (confirmed == true) {
    await DatabaseService.instance.delete(item.id!);
    _loadItems();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item deleted')),
    );
  }
}
```

## 🔧 Cara Kerja

### Database CRUD Flow

```
┌─────────────┐
│   UI Layer  │
│  (Screen)   │
└──────┬──────┘
       │
       │ Call methods
       ↓
┌─────────────┐
│   Service   │
│  (Database  │
│   Service)  │
└──────┬──────┘
       │
       │ SQL queries
       ↓
┌─────────────┐
│   SQLite    │
│  Database   │
│ (items.db)  │
└─────────────┘
```

**Process:**
1. User interacts dengan UI (button, form, etc.)
2. Screen calls DatabaseService methods
3. DatabaseService executes SQL queries
4. Data saved/retrieved dari SQLite database
5. Result returned ke UI
6. UI updates dengan setState()

**Database Location:**
- Android: `/data/data/com.example.crud_app/databases/items.db`
- iOS: `Library/Application Support/items.db`

### API CRUD Flow

```
┌─────────────┐
│   UI Layer  │
│  (Screen)   │
└──────┬──────┘
       │
       │ Call methods
       ↓
┌─────────────┐
│   Service   │
│    (API     │
│   Service)  │
└──────┬──────┘
       │
       │ HTTP requests
       ↓
┌─────────────┐
│  REST API   │
│(JSONPlace-  │
│   holder)   │
└─────────────┘
```

**Process:**
1. User interacts dengan UI
2. Screen calls ApiService methods
3. ApiService makes HTTP requests
4. Server processes request
5. Response returned (JSON)
6. JSON parsed to ItemModel
7. UI updates dengan setState()

**API Details:**
- Base URL: `https://jsonplaceholder.typicode.com`
- Endpoint: `/posts`
- Methods: GET (read), POST (create), PUT (update), DELETE (delete)
- Response: JSON format
- Note: Fake API - data tidak persistent

## 📱 Screenshots

### Home Screen
Pilih salah satu dari 4 implementasi CRUD:
- Database Multi Page (Blue)
- Database Single Page (Teal)
- API Multi Page (Purple)
- API Single Page (Orange)

### Multi Page Flow
1. List screen dengan FloatingActionButton
2. Navigate ke form screen (full screen)
3. Fill form dengan validation
4. Save dan kembali ke list
5. List auto-refresh

### Single Page Flow
1. List screen dengan FloatingActionButton
2. Dialog popup muncul
3. Fill form dalam dialog
4. Save tanpa navigation
5. Dialog close, list auto-refresh

## 🎓 Learning Points

### Beginner Level
- ✅ **CRUD Operations** - Create, Read, Update, Delete basics
- ✅ **StatefulWidget** - Managing state dengan setState()
- ✅ **Form Widgets** - TextField, TextFormField, validation
- ✅ **Navigation** - Navigator.push(), Navigator.pop()
- ✅ **Dialog** - showDialog(), AlertDialog
- ✅ **ListView** - Displaying lists of data
- ✅ **Async/Await** - Handling asynchronous operations

### Intermediate Level
- ✅ **SQLite Integration** - Local database dengan sqflite
- ✅ **REST API** - HTTP requests dengan http package
- ✅ **JSON Serialization** - toJson(), fromJson()
- ✅ **Service Pattern** - Separation of concerns
- ✅ **Error Handling** - Try-catch, user feedback
- ✅ **Loading States** - Loading, empty, error states
- ✅ **Pull to Refresh** - RefreshIndicator
- ✅ **Confirmation Dialogs** - User confirmations

### Advanced Concepts
- ✅ **Singleton Pattern** - DatabaseService singleton
- ✅ **Factory Constructors** - fromMap(), fromJson()
- ✅ **CopyWith Pattern** - Immutable updates
- ✅ **Generic Types** - Future<T>, List<T>
- ✅ **Null Safety** - Handling nullable types
- ✅ **Async Error Handling** - Proper error propagation
- ✅ **UI/UX Patterns** - Multi page vs Single page

### Architecture Patterns
- ✅ **Layered Architecture** - UI → Service → Data
- ✅ **Repository Pattern** - Data access abstraction
- ✅ **Model Classes** - Data representation
- ✅ **Service Classes** - Business logic separation

## 🎯 Best Practices Implemented

### Code Organization
```
lib/
├── models/          # Data models
├── services/        # Business logic
├── screens/         # UI screens
└── widgets/         # Reusable widgets
```

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Private**: `_leadingUnderscore`

### Error Handling
```dart
try {
  // Operation
} catch (e) {
  // Handle error
  // Show user feedback
  // Log error
}
```

### User Feedback
- ✅ Loading indicators untuk async operations
- ✅ SnackBar untuk success/error messages
- ✅ Confirmation dialogs untuk destructive actions
- ✅ Empty states dengan helpful messages
- ✅ Error states dengan retry options

### Performance
- ✅ Lazy loading dengan ListView.builder
- ✅ Efficient state updates
- ✅ Proper resource disposal (controllers)
- ✅ Async operations tidak blocking UI

## 🐛 Troubleshooting

### Database Issues

**Problem:** Database tidak terbuat atau data tidak tersimpan

**Solution:**
```bash
# Clear app data
flutter clean
flutter pub get

# Uninstall app dari device
adb uninstall com.example.crud_app

# Reinstall
flutter run
```

### API Issues

**Problem:** API requests gagal

**Solution:**
1. Check internet connection
2. Verify API endpoint: https://jsonplaceholder.typicode.com/posts
3. Check console untuk error messages
4. Try dengan Postman untuk test API

### Form Issues

**Problem:** Validation tidak bekerja

**Solution:**
- Pastikan `_formKey.currentState!.validate()` dipanggil
- Check validator functions return proper error messages
- Ensure TextFormField (bukan TextField) untuk validation

## 🚀 Next Steps

Setelah memahami project ini, coba:

1. **Add Search Feature**
   - Implement search bar
   - Filter items by title/description

2. **Add Sorting**
   - Sort by date, title, priority
   - Ascending/descending order

3. **Add Categories**
   - Filter by category
   - Category management

4. **Implement Provider**
   - Replace setState dengan Provider
   - Better state management

5. **Add Image Upload**
   - Image picker
   - Store images locally atau upload ke server

6. **Implement Real API**
   - Create your own backend
   - Replace JSONPlaceholder

7. **Add Authentication**
   - Login/Register
   - User-specific data

8. **Offline Sync**
   - Combine Database + API
   - Sync when online

## 📚 Resources

### Official Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [sqflite Package](https://pub.dev/packages/sqflite)
- [http Package](https://pub.dev/packages/http)
- [JSONPlaceholder API](https://jsonplaceholder.typicode.com/)

### Tutorials
- [Flutter CRUD Tutorial](https://flutter.dev/docs/cookbook)
- [SQLite in Flutter](https://flutter.dev/docs/cookbook/persistence/sqlite)
- [Networking in Flutter](https://flutter.dev/docs/cookbook/networking/fetch-data)

## 🤝 Contributing

Contributions are welcome! Silakan:
1. Fork repository ini
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

MIT License - Free to use untuk pembelajaran dan development.

## 👨‍💻 Author

Project ini dibuat untuk keperluan pembelajaran Flutter Mobile Programming.

---

**Dibuat dengan ❤️ menggunakan Flutter**

Mulai dengan memilih salah satu dari 4 implementasi CRUD dan explore perbedaannya!
