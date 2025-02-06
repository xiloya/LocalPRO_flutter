import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pro_model.dart';

class ProDetails extends StatelessWidget {
  final Pro pro;

  const ProDetails({Key? key, required this.pro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSection(pro: pro),
            InfoSection(pro: pro),
            const ReviewsSection(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const BookButton(),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Service Provider',
        style: TextStyle(fontFamily: 'Montserrat'),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      elevation: 3,
      shadowColor: const Color(0x1E120F28),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final Pro pro;

  const ProfileSection({Key? key, required this.pro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 3,
        child: Column(
          children: [
            Container(
              height: 233,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                pro.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pro.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const SizedBox(height: 8),
                  StarRating(
                      rating: pro.rating.toInt(), total: 5, reviews: 312),
                  const SizedBox(height: 8),
                  Text(
                    pro.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF565E6C),
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

class InfoSection extends StatelessWidget {
  final Pro pro;

  const InfoSection({Key? key, required this.pro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.category, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Category: ${pro.category}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Price: \$${pro.price}/hr',
                    style: Theme.of(context).textTheme.bodyMedium,
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

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (_, __) => const Divider(height: 32),
            itemBuilder: (context, index) => ReviewItem(
              avatarColor: index.isEven
                  ? const Color(0xFFA1CEFF)
                  : const Color(0xFFFFDDB4),
              name: index.isEven ? 'Michael Chandler' : 'Leslie Alexander',
              date: index.isEven ? 'a day ago' : 'Apr 24, 2023',
              rating: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final Color avatarColor;
  final String name;
  final String date;
  final int rating;

  const ReviewItem({
    Key? key,
    required this.avatarColor,
    required this.name,
    required this.date,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: avatarColor,
          radius: 20,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(color: Color(0xFF565E6C)),
              ),
              const SizedBox(height: 8),
              StarRating(rating: rating, total: 5, iconSize: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  final int total;
  final int reviews;
  final double iconSize;

  const StarRating({
    Key? key,
    required this.rating,
    this.total = 5,
    this.reviews = 0,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
          total,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: iconSize,
          ),
        ),
        if (reviews > 0) ...[
          const SizedBox(width: 8),
          Text(
            '($reviews)',
            style: const TextStyle(color: Color(0xFF565E6C)),
          ),
        ],
      ],
    );
  }
}

class BookButton extends StatelessWidget {
  const BookButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'Book Now',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
