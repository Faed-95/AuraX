import 'package:aura_x/Screens/home.dart';
import 'package:aura_x/Screens/widget/pages.dart';
import 'package:aura_x/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding extends StatelessWidget {
   OnBoarding({super.key});

  final PageController controller = PageController();

  //bool isLastPage = false;
  final currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = context.watch<OnBoardingProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
               context.read<OnBoardingProvider>().updateIndex(index);
                },
                children: const [
                  OnBoardingPage(
                    title: 'Where Your Music Lives',
                    content:
                        'All your local songs in one place. Fast, smooth, and beautifully organized.',
                    icon: Icons.library_music,
                  ),
                  OnBoardingPage(
                    title: 'Control Every Beat',
                    content:
                        'Background playback, shuffle, repeat, and lock-screen controls — made effortless.',
                    icon: Icons.headphones,
                  ),
                  OnBoardingPage(
                    title: 'Playlists, Your Way',
                    content:
                        'Create playlists, manage favorites, and listen completely offline.',
                    icon: Icons.queue_music,
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: onBoardingProvider.isLastPage && index == 2 ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.deepPurple
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      if (onBoardingProvider.isLastPage) {
                        controller.jumpToPage(0);
                      } else {
                        controller.jumpToPage(2);
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: Text(onBoardingProvider.isLastPage ? 'Back' : 'Skip'),
                  ),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: () async {
                      if (!onBoardingProvider.isLastPage) {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      } else {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('onBoardingDone', true);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.deepPurple, Colors.purpleAccent],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 34,
                          vertical: 16,
                        ),
                        child: Text(
                          onBoardingProvider.isLastPage ? 'Start Listening' : 'Next',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
