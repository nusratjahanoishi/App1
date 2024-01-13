class OnboardingList {
  String animation;
  String title;
  String discription;

  OnboardingList({
    required this.animation,
    required this.title,
    required this.discription,
  });
}

List<OnboardingList> list = [
  OnboardingList(
    title: 'Welcome to LifeLeaf',
    animation: 'assets/Animation - 1704557655558.json',
    discription: "Your personal guide to a healthy lifestyle "
  ),
  OnboardingList(
    title: 'Track Your Meals',
    animation: 'assets/Animation - 1704557472603.json',
    discription: "Log your meals and keep an eye on your nutrition intake. "
    ,
  ),
  OnboardingList(
    title: 'Stay Fit and Healthy',
    animation: 'assets/Animation - 1704557538037.json',
    discription: "Get personalized tips and plans for a healthier you. "
         ,
  ),
  OnboardingList(
      title: "Let's Get Started",
      animation: 'assets/Animation - 1704642555859.json',
      discription: "Start your journey to a better, healthier lifestyle now! "
  ),
];
