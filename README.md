# Early Pulse - AI for Health Tomorrow

Early Pulse is an AI-powered health monitoring application that leverages machine learning to provide real-time health tracking, predictive analytics, and personalized health recommendations. The app aims to transform healthcare by enabling early diagnosis, proactive health management, and efficient operations for healthcare providers.

## 📂 Additional Resources

If you don't want to build the APK and set up the Flutter environment, you can check the working videos here:
- [Google Drive Link](https://drive.google.com/drive/folders/12s-ibV4lWxPQ2_X4A_c6iIbFWlGdiFba)

## 📱 Features

- **Real-Time Health Monitoring**: Track your health metrics continuously.
- **Predictive Analytics**: Get AI-driven insights and early diagnosis.
- **Personalized Recommendations**: Tailored advice based on user data.
- **Admin Dashboard**: Manage user services, monitor appointments, analyze revenue, and more.

## 🛠️ Tech Stack

### User App
- **Frontend**: Flutter
- **Backend**: FastAPI, Groq API (Llama2, Langchain)
- **Database**: Firebase
- **Cloud Hosting**: AWS

### Admin Dashboard
- **Frontend**: ReactJS
- **Database**: SQL


## 🏥 Admin Features

- Manage user accounts (accept/reject)
- Upload and analyze user health reports

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**
- **FastAPI** and necessary Python packages
- **Node.js** for ReactJS
- **Java** for Spring Boot
- **Firebase account setup**
- **AWS account setup**

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/early-pulse.git
   ```

2. **Navigate to the Project Directory:**
   ```bash
   cd early-pulse
   ```

3. **Install Dependencies for the User App:**
   ```bash
   cd user-app
   flutter pub get
   ```

4. **Run the Backend:**
   Make sure to change the endpoints of the API in the app source code to match the IP address of the backend server. Ensure that both are on the same network for smooth communication.
   ```bash
   cd backend
   uvicorn main:app --reload
   ```

   ```

5. **Build the APK:**
   Set the Flutter environment and run:
   ```bash
   flutter build apk
   ```

## 🖼️ Screenshots

### User App
(Add screenshots here)

### Admin Dashboard
(Add screenshots here)

## 📊 System Architecture
(Add system architecture diagram here)

## 🤖 AI

- **Generative AI**: Utilizes Llama2 with Langchain for health report analysis and personalized recommendations.
- **Cloud Integration**: Deployed using AWS for scalability and performance.

## 🧩 Contributing

Contributions are welcome! Please follow the standard contribution guidelines:

1. Fork the project.
2. Create your feature branch:
   ```bash
   git checkout -b feature/YourFeature
   ```
3. Commit your changes:
   ```bash
   git commit -m 'Add your feature'
   ```
4. Push to the branch:
   ```bash
   git push origin feature/YourFeature
   ```
5. Open a pull request.

## 📧 Contact

For any inquiries or feedback, please reach out:
- Avanish Raj Singh - avanishraj005@gmail.com
