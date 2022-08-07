import 'package:ask_a_task/features/add/page/add_page.dart';
import 'package:ask_a_task/features/auth/pages/user_profile.dart';
import 'package:ask_a_task/features/details/pages/details_page.dart';
import 'package:ask_a_task/features/home/cubit/home_cubit.dart';
import 'package:ask_a_task/models/item_model.dart';
import 'package:ask_a_task/repositories/items_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 1000), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask A Task'),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: [
          const HomeList(),
          const AddPage(),
          const UserProfile(),
          Container(
            color: Colors.blueGrey,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        selectedFontSize: 10,
        unselectedFontSize: 5,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(color: Colors.green),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: 'Your Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: 'Your Groups'),
        ],
        currentIndex: _selectedIndex,
        onTap: onTapped,
      ),
    );
  }
}



// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Can\'t Wait'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => const UserProfile(),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.person),
//           ),
//         ],
//       ),
//       body: const _HomePageBody(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const AddPage(),
//               fullscreenDialog: true,
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

class HomeList extends StatelessWidget {
  const HomeList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(ItemsRepository())..start(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final itemModels = state.items;
          if (itemModels.isEmpty) {
            return const SizedBox.shrink();
          }
          return ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            children: [
              for (final itemModel in itemModels)
                Dismissible(
                  key: ValueKey(itemModel.id),
                  background: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 32.0),
                        child: Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    // only from right to left
                    return direction == DismissDirection.endToStart;
                  },
                  onDismissed: (direction) {
                    context.read<HomeCubit>().remove(documentID: itemModel.id);
                  },
                  child: _ListViewItem(
                    itemModel: itemModel,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ListViewItem extends StatelessWidget {
  const _ListViewItem({
    Key? key,
    required this.itemModel,
  }) : super(key: key);

  final ItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailsPage(id: itemModel.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  image: DecorationImage(
                    image: NetworkImage(
                      itemModel.imageURL,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            itemModel.title,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            itemModel.releaseDateFormatted(),
                            // (document['release_date'] as Timestamp)
                            //     .toDate()
                            //     .toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          itemModel.daysLeft(),
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('days left'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
