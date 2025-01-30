


# KunchoMonitor - Activity Monitoring for Kuncho

![KunchoMonitor Banner](https://via.placeholder.com/1000x300?text=KunchoMonitor)  

**KunchoMonitor** is an **activity monitoring service** designed for the **Kuncho** kids' entertainment platform. It helps users interact with contents using REST methods and tracks everytime a content is retrieved.



## **🚀 Features**  
✅ Logs an activity everytime a content is accessed
✅ Secure data storage and retrieval  
✅ RESTful API for easy integration with Kuncho  
✅ Built with .NET and MongoDB
✅ Searching functionality for better data filtering  
✅ Pagination for searching to improve efficiency and performance  



## **🛠️ Tech Stack**  
- **Backend:** .NET Core / ASP.NET Web API  
- **Database:** MongoDB  
- **Authentication:** JWT-based authentication  
- **Containerization (optional):** Docker  



## **📦 Installation & Setup**  

### **1️⃣ Clone the Repository**  
```bash
git clone https://github.com/senagal/KunchoMonitor.git
cd KunchoMonitor
```

### **2️⃣ Install Dependencies**  
```bash
dotnet restore
```

### **3️⃣ Configure Environment Variables**  
- Create an `appsettings.json` file in the root directory  
- Add MongoDB connection string and other required configurations  

Example:  
```json
{
  "ConnectionStrings": {
    "MongoDb": "mongodb://localhost:27017/KunchoMonitorDB"
  },
  "JwtSettings": {
    "Secret": "YourSecretKeyHere"
  }
}
```

### **4️⃣ Run the Project**  
```bash
dotnet run
```
The API will be available at `http://localhost:5000`.  

---

## **📡 API Endpoints**  

| Method | Endpoint         | Description                  |  
|--------|-----------------|------------------------------|  
| `GET`  | `/api/activity` | Get all monitored activities |  
| `POST` | `/api/activity` | Log a new user activity      |  
| `GET`  | `/api/users`    | Retrieve registered users    |  

🔹 More API endpoints and request/response examples can be found in the [API Documentation](#) (link if available).  



## **🧪 Running Tests**  
Run unit tests to ensure everything works properly:  
```bash
dotnet test
```



## **👥 Contributing**  
We welcome contributions! To contribute:  
1. Fork the repository  
2. Create a feature branch (`git checkout -b feature-name`)  
3. Commit your changes (`git commit -m "Add feature"`)  
4. Push to the branch (`git push origin feature-name`)  
5. Open a **Pull Request**  



## **📄 License**  
This project is licensed under the **MIT License**. See the `LICENSE` file for more details.  

