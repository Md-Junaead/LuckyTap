// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/game_provider.dart';
// import '../widgets/number_button.dart';

// class GameScreen extends StatelessWidget {
//   const GameScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<GameProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         return Scaffold(
//           appBar: AppBar(
//             title: DecoratedBox(
//               decoration: const BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: Colors.red, width: 2.0),
//                 ),
//               ),
//               child: const Text(
//                 'Lucky Tap',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             centerTitle: true,
//           ),
//           body: SafeArea(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Number: ${provider.lastNumber}',
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                   Text(
//                     'Points: ${provider.gameState.points}',
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                   Text(
//                     'Level: ${provider.gameState.level}',
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                   const SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Text(
//                       '"${provider.lastQuote}"',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontStyle: FontStyle.italic,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   NumberButton(onPressed: provider.generateNumber),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: provider.resetGame,
//                     style: ElevatedButton.styleFrom(
//                       textStyle: const TextStyle(fontSize: 18),
//                     ),
//                     child: const Text('Reset Game'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/number_button.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.red, width: 2.0),
                ),
              ),
              child: const Text(
                'Lucky Tap',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  provider.isAudioEnabled ? Icons.volume_up : Icons.volume_off,
                ),
                onPressed: provider.toggleAudio,
                tooltip:
                    provider.isAudioEnabled ? 'Mute Audio' : 'Unmute Audio',
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Number: ${provider.lastNumber}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Points: ${provider.gameState.points}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(
                    'Level: ${provider.gameState.level}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '"${provider.lastQuote}"',
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  NumberButton(onPressed: provider.generateNumber),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: provider.resetGame,
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Reset Game'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
