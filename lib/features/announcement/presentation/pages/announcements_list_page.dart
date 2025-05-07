import 'package:domochat/features/announcement/data/models/announcement_model.dart';
import 'package:domochat/features/announcement/presentation/bloc/announcement_bloc.dart';
import 'package:domochat/features/announcement/presentation/bloc/announcement_event.dart';
import 'package:domochat/features/announcement/presentation/bloc/announcement_state.dart';
import 'package:domochat/features/announcement/presentation/pages/announcement_detail_page.dart';
import 'package:domochat/features/announcement/presentation/pages/create_announcement_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementsListPage extends StatefulWidget {
  final String communityId;
  const AnnouncementsListPage({super.key, required this.communityId});

  @override
  State<AnnouncementsListPage> createState() => _AnnouncementsListPageState();
}

class _AnnouncementsListPageState extends State<AnnouncementsListPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AnnouncementBloc>(context)
        .add(FetchAnnouncements(communityId: widget.communityId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Объявления',
          style: TextStyle(color: Colors.blue[800]),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: BlocBuilder<AnnouncementBloc, AnnouncementState>(
        builder: (context, state) {
          if (state is AnnouncementLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is AnnouncementLoadedState) {
            if (state.announcements.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('Нет активных объявлений')),
              );
            }
            return _buildAnnouncementsGrid(
                state.announcements as List<AnnouncementModel>);
          } else if (state is AnnouncementErrorState) {
            return Center(
              child: Text('Ошибка загрузки ${state.message}'),
            );
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateAnnouncementPage(communityId: widget.communityId,)),
        ),
        backgroundColor: Colors.blue[800],
        child: Icon(
          Icons.add_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAnnouncementsGrid(List<AnnouncementModel> announcements) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AnnouncementDetailPage(announcement: announcement),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[500]!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(6)),
                        child: announcement.imageUrls.isNotEmpty
                          ? Image.network(
                            announcement.imageUrls[0],
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                          )
                          : _buildPlaceholderImage(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            '${announcement.price} ₽',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 14,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                announcement.author,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: Center(child: Icon(Icons.photo, size: 50, color: Colors.grey[400], weight: 100,))
    );
  }
}
