import 'package:domochat/features/announcement/data/models/announcement_model.dart';
import 'package:flutter/material.dart';

class AnnouncementDetailPage extends StatefulWidget {
  final AnnouncementModel announcement;
  const AnnouncementDetailPage({super.key, required this.announcement});

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Объявление', style: TextStyle(color: Colors.blue[800])),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: widget.announcement.imageUrls.length,
                  itemBuilder: (context, index) => Image.asset(
                    widget.announcement.imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.announcement.title,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${widget.announcement.price} ₽',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildInfoSection('Описание', widget.announcement.description),
                  SizedBox(height: 30),
                  _buildInfoSection('Автор', widget.announcement.author),
                  SizedBox(height: 30),
                  _buildInfoSection('Дата публикации',
                      widget.announcement.date),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        Divider(color: Colors.grey[300], height: 40),
      ],
    );
  }
}
