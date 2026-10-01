
import 'package:flutter/material.dart';

void main() => runApp(const DfcApp());

class Food {
  final String name, image, desc;
  final int price;
  Food(this.name, this.image, this.desc, this.price);
}

final foods = [
  Food('Hot & Crispy Chicken', 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=900', 'Crispy, juicy and full of flavour', 149),
  Food('Chicken Popcorn', 'https://images.unsplash.com/photo-1562967916-eb82221dfb92?w=900', 'Bite-sized crispy chicken', 129),
  Food('Chicken Strips', 'https://images.unsplash.com/photo-1562967916-eb82221dfb92?w=900', 'Tender strips with crispy coating', 119),
  Food('Zinger Burger', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900', 'Crispy chicken burger', 129),
];

class DfcApp extends StatelessWidget {
  const DfcApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DFC Home Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE50914)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  final cart = <Food>[];

  void add(Food f) => setState(() => cart.add(f));

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onAdd: add, onOpen: (f) => Navigator.push(context, MaterialPageRoute(
        builder: (_) => FoodDetails(food: f, onAdd: () { add(f); Navigator.pop(context); }),
      ))),
      MenuPage(onAdd: add, onOpen: (f) => Navigator.push(context, MaterialPageRoute(
        builder: (_) => FoodDetails(food: f, onAdd: () { add(f); Navigator.pop(context); }),
      ))),
      OrdersPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
      floatingActionButton: cart.isEmpty ? null : FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE50914),
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => CartPage(items: cart, onCheckout: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPage()))),
        )),
        icon: const Icon(Icons.shopping_bag_outlined),
        label: Text('Cart (${cart.length})'),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final String title;
  const Header(this.title, {super.key});
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
    child: Row(children: [
      const Icon(Icons.location_on, color: Color(0xFFE50914)),
      const SizedBox(width: 5),
      Expanded(child: Text('Hyderabad', style: const TextStyle(fontWeight: FontWeight.bold))),
      Text(title, style: const TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.bold)),
    ]),
  );
}

class HomePage extends StatelessWidget {
  final void Function(Food) onAdd;
  final void Function(Food) onOpen;
  const HomePage({super.key, required this.onAdd, required this.onOpen});
  @override Widget build(BuildContext context) => SafeArea(
    child: ListView(padding: const EdgeInsets.all(16), children: [
      const Header('DFC'),
      const Text('Good food, delivered fast!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
      const SizedBox(height: 14),
      TextField(decoration: InputDecoration(
        hintText: 'Search your favourite food...',
        prefixIcon: const Icon(Icons.search),
        filled: true, fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      )),
      const SizedBox(height: 16),
      Container(
        height: 170, padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: const Color(0xFFE50914), borderRadius: BorderRadius.circular(22)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('BIG SAVINGS', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('UPTO 40% OFF', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.red), child: const Text('ORDER NOW'))
          ])),
          const Text('🍗', style: TextStyle(fontSize: 70)),
        ]),
      ),
      const SizedBox(height: 22),
      const Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
        Category(icon: '🍗', name: 'Chicken'), Category(icon: '🍔', name: 'Burgers'),
        Category(icon: '🍟', name: 'Combos'), Category(icon: '🥤', name: 'Drinks'),
      ]),
      const SizedBox(height: 22),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
        Text('Popular Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('See All', style: TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.bold)),
      ]),
      const SizedBox(height: 12),
      SizedBox(height: 245, child: ListView.separated(
        scrollDirection: Axis.horizontal, itemCount: foods.length,
        separatorBuilder: (_,__) => const SizedBox(width: 12),
        itemBuilder: (_,i) => FoodCard(food: foods[i], onAdd: onAdd, onOpen: onOpen),
      )),
    ]),
  );
}

class Category extends StatelessWidget {
  final String icon, name;
  const Category({super.key, required this.icon, required this.name});
  @override Widget build(BuildContext context) => Column(children: [
    CircleAvatar(radius: 30, backgroundColor: const Color(0xFFFFEEEE), child: Text(icon, style: const TextStyle(fontSize: 28))),
    const SizedBox(height: 5), Text(name)
  ]);
}

class FoodCard extends StatelessWidget {
  final Food food; final void Function(Food) onAdd; final void Function(Food) onOpen;
  const FoodCard({super.key, required this.food, required this.onAdd, required this.onOpen});
  @override Widget build(BuildContext context) => InkWell(
    onTap: () => onOpen(food),
    child: Container(width: 185, decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18), color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 12)]
    ), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        child: Image.network(food.image, height: 120, width: 185, fit: BoxFit.cover,
          errorBuilder: (_,__,___) => Container(height:120,color:Colors.grey.shade200,child:const Icon(Icons.fastfood,size:45)))),
      Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(food.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('₹${food.price}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 5),
        SizedBox(width: double.infinity, child: FilledButton(
          onPressed: () => onAdd(food), style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE50914)),
          child: const Text('Add +')))
      ]))
    ]),
  );
}

class MenuPage extends StatelessWidget {
  final void Function(Food) onAdd; final void Function(Food) onOpen;
  const MenuPage({super.key, required this.onAdd, required this.onOpen});
  @override Widget build(BuildContext context) => SafeArea(child: ListView(
    padding: const EdgeInsets.all(16), children: [
      const Header('Menu'),
      const Text('Our Menu', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
      const SizedBox(height: 12),
      Wrap(spacing: 8, children: ['All','Chicken','Burgers','Combos','Snacks'].map((x) => Chip(
        label: Text(x), backgroundColor: x=='All'?const Color(0xFFFFE5E5):Colors.grey.shade100,
      )).toList()),
      const SizedBox(height: 14),
      ...foods.map((f) => ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 7),
        leading: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(f.image,width:75,height:75,fit:BoxFit.cover,errorBuilder:(_,__,___)=>Container(width:75,height:75,color:Colors.grey.shade200,child:const Icon(Icons.fastfood)))),
        title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('₹${f.price}  •  ${f.desc}'),
        trailing: FilledButton(onPressed:()=>onAdd(f), child: const Text('Add +')),
        onTap: ()=>onOpen(f),
      ))
    ],
  ));
}

class FoodDetails extends StatelessWidget {
  final Food food; final VoidCallback onAdd;
  const FoodDetails({super.key, required this.food, required this.onAdd});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Food Details')),
    body: Column(children: [
      Image.network(food.image,height:280,width:double.infinity,fit:BoxFit.cover,errorBuilder:(_,__,___)=>Container(height:280,color:Colors.grey.shade200)),
      Expanded(child: ListView(padding: const EdgeInsets.all(18), children: [
        Text(food.name,style:const TextStyle(fontSize:27,fontWeight:FontWeight.w800)),
        Text('₹${food.price}',style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:Color(0xFFE50914))),
        const SizedBox(height:8), Text(food.desc),
        const SizedBox(height:20), const Text('Add-ons',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
        CheckboxListTile(value:true,onChanged:(_){},title:const Text('Extra Dip'),secondary:const Text('+₹20')),
        CheckboxListTile(value:false,onChanged:(_){},title:const Text('Coleslaw'),secondary:const Text('+₹30')),
      ])),
      Padding(padding:const EdgeInsets.all(16),child:SizedBox(width:double.infinity,height:54,child:FilledButton(
        onPressed:onAdd,style:FilledButton.styleFrom(backgroundColor:const Color(0xFFE50914)),child:Text('Add to Cart  •  ₹${food.price}'))))
    ]),
  );
}

class CartPage extends StatelessWidget {
  final List<Food> items; final VoidCallback onCheckout;
  const CartPage({super.key, required this.items, required this.onCheckout});
  @override Widget build(BuildContext context) {
    final total=items.fold<int>(0,(s,f)=>s+f.price);
    return Scaffold(appBar:AppBar(title:const Text('Your Cart')),body:Column(children:[
      Expanded(child:ListView.builder(itemCount:items.length,itemBuilder:(_,i)=>ListTile(
        leading:CircleAvatar(backgroundImage:NetworkImage(items[i].image)),title:Text(items[i].name),subtitle:Text('₹${items[i].price}'),trailing:const Text('1x'),
      ))),
      Padding(padding:const EdgeInsets.all(18),child:Column(children:[
        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[const Text('Subtotal'),Text('₹$total')]),
        const Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text('Delivery Fee'),Text('₹40')]),
        const Divider(),
        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[const Text('Total',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),Text('₹${total+40}',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold))]),
        const SizedBox(height:12),SizedBox(width:double.infinity,height:52,child:FilledButton(
          onPressed:onCheckout,style:FilledButton.styleFrom(backgroundColor:const Color(0xFFE50914)),child:const Text('Proceed to Checkout')))
      ]))
    ]));
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override State<CheckoutPage> createState()=>_CheckoutPageState();
}
class _CheckoutPageState extends State<CheckoutPage> {
  String pay='UPI';
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Checkout')),
    body:ListView(padding:const EdgeInsets.all(18),children:[
      const Text('Delivery Address',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      const SizedBox(height:8),Card(child:ListTile(leading:const Icon(Icons.home,color:Color(0xFFE50914)),title:const Text('Home'),subtitle:const Text('Add your delivery address'),trailing:const Icon(Icons.chevron_right))),
      const SizedBox(height:22),const Text('Payment Method',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      ...['UPI','Credit / Debit Card','Cash on Delivery'].map((x)=>RadioListTile(value:x,groupValue:pay,onChanged:(v)=>setState(()=>pay=v!),title:Text(x))),
      const SizedBox(height:25),SizedBox(height:54,child:FilledButton(
        onPressed:()=>Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const TrackingPage())),
        style:FilledButton.styleFrom(backgroundColor:const Color(0xFFE50914)),child:const Text('Place Order')))
    ])
  );
}

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Track Order')),body:ListView(padding:const EdgeInsets.all(20),children:[
    const Text('Order #DFC123456',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
    const SizedBox(height:30),
    ...['Order Confirmed','Preparing Your Food','Picked Up','On the Way','Delivered'].asMap().entries.map((e)=>ListTile(
      leading:CircleAvatar(backgroundColor:e.key<4?Colors.green:Colors.grey,child:Icon(e.key<4?Icons.check:Icons.circle,color:Colors.white)),
      title:Text(e.value,style:const TextStyle(fontWeight:FontWeight.bold)),
      subtitle:Text(e.key<4?'Completed':'Pending'),
    )),
  ]));
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override Widget build(BuildContext context)=>const SafeArea(child:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
    Icon(Icons.receipt_long,size:70,color:Color(0xFFE50914)),SizedBox(height:12),
    Text('No recent orders',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
    Text('Your completed orders will appear here.')
  ])));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override Widget build(BuildContext context)=>SafeArea(child:ListView(padding:const EdgeInsets.all(18),children:[
    const Center(child:CircleAvatar(radius:42,child:Icon(Icons.person,size:45))),
    const SizedBox(height:10),const Center(child:Text('DFC Customer',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold))),
    const SizedBox(height:25),
    ...['My Orders','Saved Addresses','Offers & Rewards','Help & Support','About DFC'].map((x)=>Card(child:ListTile(title:Text(x),trailing:const Icon(Icons.chevron_right))))
  ]));
}
