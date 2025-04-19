class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent({
    required this.description,
    required this.image,
    required this.title,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    description: 'Pick your Med from our backpack More than 300+ med',
    image: "images/screen1.png",
    title: 'Select from Our Best Med',
  ),
  UnboardingContent(
    description: 'You can pay cash on delivery and Card payment is available',
    image: "images/screen2.png",
    title: 'Easy and Online Payment',
  ),
  UnboardingContent(
    description: 'Deliver your Med at your Doorstep',
    image: "images/screen3.png",
    title: 'Quick Delivery at Your Doorstep',
  ),
];
