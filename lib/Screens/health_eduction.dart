import 'package:flutter/material.dart';

class HealthEducation extends StatefulWidget {
  const HealthEducation({super.key});

  @override
  State<HealthEducation> createState() => _HealthEducationState();
}

class _HealthEducationState extends State<HealthEducation> {
  final List<String> blogTitles = [
    "Understanding Hypertension: The Silent Killer",
    "Diabetes Management: The Role of Health Education",
    "Cancer Awareness: How Health Education Can Save Lives",
    "Combating Respiratory Diseases: The Need for Health Education",
    "Understanding Alzheimer’s Disease: The Role of Health Education",
    "Preventing Infectious Diseases: The Power of Health Education",
  ];

  final List<String> blogIntro = [
    "Hypertension, or high blood pressure, is often called the silent killer because it can go unnoticed for years while quietly damaging your body. This blog provides essential health education on understanding, preventing, and managing hypertension.",
    "Diabetes is a chronic condition affecting millions worldwide. This blog focuses on the critical role of health education in managing diabetes and improving quality of life.",
    "Cancer remains one of the leading causes of death globally. This blog explores how health education on cancer awareness, prevention, and early detection can significantly impact survival rates.",
    "Respiratory diseases, such as asthma, chronic obstructive pulmonary disease (COPD), and lung infections, are common yet often preventable. This blog discusses the importance of health education in managing and preventing respiratory diseases.",
    "Alzheimer's disease is a progressive neurological disorder that affects memory and cognitive function. This blog explores how health education can aid in understanding, managing, and supporting those affected by Alzheimer's.",
    "Infectious diseases, such as influenza, tuberculosis, and COVID-19, pose significant public health challenges. This blog highlights how health education is a powerful tool in preventing the spread of infectious diseases.",
  ];

  final List<String> blogBody = [
    "Hypertension is a condition where the force of the blood against the artery walls is consistently too high, leading to heart disease, stroke, and other serious health problems. Many people with hypertension may not experience any symptoms, making regular blood pressure checks crucial. Health education on hypertension involves understanding risk factors like poor diet, lack of exercise, obesity, and stress. By adopting a healthier lifestyle, such as reducing salt intake, exercising regularly, and managing stress, individuals can prevent or manage hypertension effectively. Medication may also be necessary, so it's important to follow a healthcare provider's advice.",
    "Diabetes occurs when the body cannot properly process glucose, leading to elevated blood sugar levels. There are two main types: Type 1, where the body doesn't produce insulin, and Type 2, where the body doesn't use insulin properly. Health education is vital in managing diabetes, as it empowers individuals with the knowledge to monitor their blood sugar levels, maintain a balanced diet, and stay active. Understanding the importance of regular check-ups, medication adherence, and recognizing early signs of complications are also crucial. Education can help prevent the onset of Type 2 diabetes and manage both types effectively, reducing the risk of serious complications like heart disease, nerve damage, and kidney failure.",
    "Cancer develops when abnormal cells in the body grow uncontrollably, forming tumors or spreading through the body. Health education is essential in raising awareness about the risk factors for cancer, such as smoking, excessive alcohol consumption, poor diet, and lack of physical activity. Education on the importance of regular screenings, such as mammograms, Pap tests, and colonoscopies, can lead to early detection when cancer is most treatable. Additionally, teaching people about the warning signs of cancer, such as unexplained weight loss, persistent cough, or unusual lumps, can prompt earlier medical attention.",
    "Respiratory diseases can range from mild to life-threatening and are often caused or exacerbated by factors like smoking, air pollution, and infections. Health education plays a crucial role in teaching individuals how to protect their respiratory health. For instance, smoking cessation programs, awareness about the dangers of secondhand smoke, and information on reducing exposure to air pollutants are vital. In managing conditions like asthma, education on recognizing triggers, proper use of inhalers, and the importance of regular check-ups can prevent exacerbations and improve quality of life.",
    "Alzheimer's disease is the most common cause of dementia and primarily affects older adults. Health education can help individuals and families understand the early signs of Alzheimer's, such as memory loss, confusion, and difficulty with daily tasks. Early diagnosis and intervention can slow the progression of the disease and improve quality of life. Education also plays a role in providing caregivers with the tools and support they need to care for loved ones with Alzheimer's. This includes information on managing symptoms, creating a safe environment, and accessing community resources for additional support.",
    "Infectious diseases are caused by pathogens like viruses, bacteria, and parasites and can spread rapidly within communities. Health education is crucial in teaching people how to protect themselves and others from these diseases. This includes promoting vaccination, educating on proper hygiene practices like handwashing, and encouraging the use of protective measures like masks and social distancing during outbreaks. Understanding the importance of following public health guidelines and recognizing symptoms early can also prevent the spread of infectious diseases and reduce the burden on healthcare systems.",
  ];

  final List<String> blogImages = [
    "assets/image-1.jpg",
    "assets/image-2.jpg",
    "assets/image-3.jpg",
    "assets/image-4.jpg",
    "assets/image-5.jpg",
    "assets/image-6.jpg",
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Education"),
      ),
      body: Stack(
        children: [
          PageView.builder(
            itemCount: blogTitles.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return BlogPage(
                title: blogTitles[index],
                intro: blogIntro[index],
                body: blogBody[index],
                imagePath: blogImages[index],
              );
            },
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(blogTitles.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  width: currentPage == index ? 12.0 : 8.0,
                  height: currentPage == index ? 12.0 : 8.0,
                  decoration: BoxDecoration(
                    color: currentPage == index ? Colors.blue : Colors.grey,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class BlogPage extends StatelessWidget {
  final String title;
  final String intro;
  final String body;
  final String imagePath;

  BlogPage(
      {required this.title,
      required this.intro,
      required this.body,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                intro,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    body,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}