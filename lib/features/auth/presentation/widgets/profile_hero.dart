import 'package:flutter/material.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.profileImageProvider,
    required this.onEditTap,
  });

  final ImageProvider? profileImageProvider;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE8D9AE),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          Positioned(
            top: 150,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 58,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: const Color(0xFFF3F3F3),
                    backgroundImage: profileImageProvider,
                    child: profileImageProvider == null
                        ? const Icon(
                            Icons.person_outline_rounded,
                            size: 48,
                            color: Colors.black45,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onEditTap,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.edit_outlined, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
