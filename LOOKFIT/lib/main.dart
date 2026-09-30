import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const LookfitApp());

const Color dark = Color(0xFF161915);
const Color lime = Color(0xFFD7F75B);
const Color light = Color(0xFFF7F7F2);

class Garment {
  final String name;
  final String category;
  final String color;
  final int price;
  final IconData symbol;
  const Garment(this.name, this.category, this.color, this.price, this.symbol);
}

const List<Garment> garments = [
  Garment('Classic White Tee', 'Tops', 'White', 29, Icons.checkroom_outlined),
  Garment('Essential Black Top', 'Tops', 'Black', 35, Icons.checkroom),
  Garment('Sand Oversized Jacket', 'Jackets', 'Sand', 89, Icons.dry_cleaning),
  Garment('Midnight Blazer', 'Jackets', 'Black', 110, Icons.dry_cleaning_outlined),
  Garment('Straight Denim', 'Bottoms', 'Blue', 59, Icons.accessibility_new),
  Garment('Tailored Black Pants', 'Bottoms', 'Black', 68, Icons.accessibility_new_outlined),
  Garment('Soft Beige Dress', 'Dresses', 'Beige', 76, Icons.woman_outlined),
  Garment('Evening Black Dress', 'Dresses', 'Black', 95, Icons.woman),
];

class LookfitApp extends StatelessWidget {
  const LookfitApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'LOOKFIT',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: light,
      colorScheme: ColorScheme.fromSeed(seedColor: lime),
      appBarTheme: const AppBarTheme(backgroundColor: light, foregroundColor: dark),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
        backgroundColor: dark, foregroundColor: Colors.white,
        minimumSize: const Size(10, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      )),
    ),
    home: const LoginPage(),
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Padding(
      padding: const EdgeInsets.all(26),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 25),
        const Text('LOOKFIT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 24)),
        const Spacer(),
        const Text('Your fitting room,\nin your pocket.', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 42, height: 1.08)),
        const SizedBox(height: 14),
        const Text('Choose a garment. Add your photo. See and save your favorite styles.',
          style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)),
        const Spacer(),
        FilledButton(onPressed: () => Navigator.pushReplacement(context,
          MaterialPageRoute<void>(builder: (_) => const LookfitHome())),
          child: const Center(child: Text('GET STARTED AS GUEST'))),
        const SizedBox(height: 12),
        const Center(child: Text('LOOKFIT v0.1 · Preview edition', style: TextStyle(color: Colors.black45))),
        const SizedBox(height: 12),
      ]),
    )),
  );
}

class LookfitHome extends StatefulWidget {
  const LookfitHome({super.key});
  @override
  State<LookfitHome> createState() => _LookfitHomeState();
}

class _LookfitHomeState extends State<LookfitHome> {
  final ImagePicker picker = ImagePicker();
  File? photo;
  int page = 0;
  String filter = 'All';
  final List<Garment> saved = [];

  Future<void> selectPhoto(ImageSource source) async {
    try {
      final XFile? selected = await picker.pickImage(
        source: source, imageQuality: 85, maxWidth: 1600,
      );
      if (!mounted) return;
      if (selected != null) setState(() => photo = File(selected.path));
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open photo: ' + err.toString())),
      );
    }
  }

  void openPhotoPicker() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Your fitting photo', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Use a well-lit, front-facing, full-body image. This demo does not upload it to a server.'),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () { Navigator.pop(sheetContext); selectPhoto(ImageSource.camera); },
            icon: const Icon(Icons.camera_alt_outlined), label: const Text('TAKE A PHOTO'),
          ),
          OutlinedButton.icon(
            onPressed: () { Navigator.pop(sheetContext); selectPhoto(ImageSource.gallery); },
            icon: const Icon(Icons.photo_library_outlined), label: const Text('CHOOSE FROM GALLERY'),
          ),
        ]),
      )),
    );
  }

  Widget portrait({double height = 230}) => ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: Container(
      height: height, width: double.infinity, color: const Color(0xFFE9EBE2),
      child: photo == null
        ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.person_outline_rounded, size: 70, color: Colors.black38),
            SizedBox(height: 10),
            Text('Your photo goes here', style: TextStyle(fontWeight: FontWeight.w800)),
            Text('Tap ADD MY PHOTO below', style: TextStyle(color: Colors.black54)),
          ])
        : Image.file(photo!, fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
              const Center(child: Text('Photo no longer available'))),
    ),
  );

  Widget garmentCard(Garment item) => InkWell(
    onTap: () => openGarment(item),
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFFECEEE8), borderRadius: BorderRadius.circular(15)),
          child: Icon(item.symbol, size: 72, color: dark),
        )),
        const SizedBox(height: 9),
        Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        Text(item.category + ' · ' + item.color,
          style: const TextStyle(color: Colors.black54, fontSize: 12)),
        const SizedBox(height: 5),
        Text('€' + item.price.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
    ),
  );

  Widget garmentGrid(List<Garment> data) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: data.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .77,
    ),
    itemBuilder: (context, index) => garmentCard(data[index]),
  );

  void openGarment(Garment item) => Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (detailContext) => Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: Container(
            decoration: BoxDecoration(color: const Color(0xFFE9ECE4), borderRadius: BorderRadius.circular(25)),
            child: Icon(item.symbol, size: 175, color: dark),
          )),
          const SizedBox(height: 18),
          Text(item.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text(item.category + ' · ' + item.color + ' · €' + item.price.toString(),
            style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () { Navigator.pop(detailContext); openTryOn(item); },
            icon: const Icon(Icons.auto_awesome_outlined), label: const Text('TRY ON ME'),
          ),
        ]),
      )),
    )),
  );

  void openTryOn(Garment item) {
    if (photo == null) {
      openPhotoPicker();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your fitting photo first.')),
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Virtual Fitting Room')),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: Stack(fit: StackFit.expand, children: [
            portrait(height: double.infinity),
            Positioned(top: 14, left: 14, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: lime, borderRadius: BorderRadius.circular(20)),
              child: const Text('DEMO PREVIEW', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
            )),
            Positioned(bottom: 14, left: 14, right: 14,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: dark, borderRadius: BorderRadius.circular(19)),
                child: Row(children: [
                  Icon(item.symbol, color: lime, size: 47),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                      Text(item.color + ' · €' + item.price.toString(),
                        style: const TextStyle(color: Colors.white70)),
                      const Text('AI garment rendering comes in v0.2.',
                        style: TextStyle(color: lime, fontSize: 11)),
                    ],
                  )),
                ]),
              ),
            ),
          ])),
          const SizedBox(height: 12),
          const Text('Your photo and garment are shown as a concept preview. This is not an AI-generated try-on.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 13),
          FilledButton.icon(
            onPressed: () {
              setState(() => saved.add(item));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Look saved in this demo session.')),
              );
            },
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('SAVE THIS LOOK'),
          ),
          OutlinedButton(onPressed: () => Navigator.pop(context),
            child: const Text('TRY ANOTHER')),
        ]),
      )),
    )));
  }

  Widget homePage() => ListView(
    padding: const EdgeInsets.all(20), children: [
      const Text('YOUR PERSONAL STYLE STUDIO',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
      const SizedBox(height: 15),
      const Text('Your style.\nYour rules.', style: TextStyle(fontSize: 40, height: 1.03, fontWeight: FontWeight.w900)),
      const SizedBox(height: 9),
      const Text('Choose a look and explore before you shop.',
        style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 24),
      portrait(height: 238),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: openPhotoPicker,
        icon: Icon(photo == null ? Icons.add_a_photo_outlined : Icons.refresh),
        label: Text(photo == null ? 'ADD MY PHOTO' : 'CHANGE MY PHOTO'),
      ),
      const SizedBox(height: 24),
      const Text('Popular right now', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      garmentGrid(garments.take(4).toList()),
      const SizedBox(height: 12),
      OutlinedButton(onPressed: () => setState(() => page = 1),
        child: const Text('DISCOVER ALL CLOTHES')),
    ],
  );

  Widget catalogPage() {
    final filtered = garments.where((item) => filter == 'All' || item.category == filter).toList();
    return ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Discover', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
      const SizedBox(height: 5),
      const Text('Select a garment to preview it with your photo.',
        style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 18),
      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
        for (final option in ['All','Tops','Bottoms','Jackets','Dresses'])
          Padding(padding: const EdgeInsets.only(right: 7), child: ChoiceChip(
            label: Text(option), selected: filter == option,
            onSelected: (selected) { if (selected) setState(() => filter = option); },
          )),
      ])),
      const SizedBox(height: 17),
      garmentGrid(filtered),
    ]);
  }

  Widget looksPage() => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Saved Looks', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
    const SizedBox(height: 6),
    const Text('Session-only favorites · No account required',
      style: TextStyle(color: Colors.black54)),
    const SizedBox(height: 17),
    if (saved.isEmpty)
      const Padding(padding: EdgeInsets.all(30),
        child: Center(child: Text('Your saved outfits will appear here.'))),
    for (final item in saved)
      Card(color: Colors.white, child: ListTile(
        leading: Icon(item.symbol, size: 38),
        title: Text(item.name), subtitle: Text(item.color + ' · €' + item.price.toString()),
        trailing: IconButton(icon: const Icon(Icons.delete_outline),
          onPressed: () => setState(() => saved.remove(item))),
        onTap: () => openTryOn(item),
      )),
  ]);

  Widget profilePage() => ListView(padding: const EdgeInsets.all(20), children: [
    const Text('Your Profile', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
    const SizedBox(height: 16),
    portrait(),
    const SizedBox(height: 12),
    FilledButton.icon(onPressed: openPhotoPicker,
      icon: const Icon(Icons.add_a_photo_outlined),
      label: const Text('CHANGE FITTING PHOTO')),
    const SizedBox(height: 20),
    const ListTile(leading: Icon(Icons.shield_outlined), title: Text('Privacy'),
      subtitle: Text('Your selected photo remains local in v0.1.')),
    const ListTile(leading: Icon(Icons.info_outline), title: Text('App version'),
      subtitle: Text('LOOKFIT v0.1 · Demo preview. AI is not connected.')),
    TextButton(onPressed: () => setState(() { photo = null; saved.clear(); }),
      child: const Text('Clear photo and saved looks')),
  ]);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('LOOKFIT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
      actions: [IconButton(
        onPressed: openPhotoPicker,
        tooltip: 'Add fitting photo',
        icon: const Icon(Icons.add_a_photo_outlined),
      )],
    ),
    body: IndexedStack(index: page,
      children: [homePage(), catalogPage(), looksPage(), profilePage()]),
    bottomNavigationBar: NavigationBar(
      selectedIndex: page,
      onDestinationSelected: (value) => setState(() => page = value),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Discover'),
        NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'Looks'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    ),
  );
}
