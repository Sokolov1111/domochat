import 'package:domochat/features/resource/data/models/resource_model.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_bloc.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_event.dart';
import 'package:domochat/features/resource/presentation/bloc/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResourcesPage extends StatefulWidget {
  final String communityId;
  const ResourcesPage({super.key, required this.communityId});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final Map<String, bool> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ResourceBloc>(context)
      .add(FetchResources(communityId: widget.communityId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Полезные контакты',
          style: TextStyle(
            color: Colors.blueGrey
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: BlocBuilder<ResourceBloc, ResourceState>(
        builder: (context, state) {
          if (state is ResourceLoadingState) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (state is ResourceLoadedState) {
            if (state.resources.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('Ещё нет полезных контактов'),),
              );
            }
            return _buildResourcesList(state.resources as List<ResourceModel>);
          } else if (state is ResourceErrorState) {
            return Center(child: Text('Ошибка загрузки - ${state.message}'),);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildResourcesList(List<ResourceModel> resources) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          final isExpanded = _expandedItems[resource.id] ?? false;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    resource.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 16, color: Colors.grey,),
                          const SizedBox(width: 4,),
                          Text(
                            resource.contactInfo,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4,),
                      Chip(
                        label: Text(resource.category),
                        backgroundColor: Colors.blue[50],
                        labelStyle: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    isExpanded ? Icons.expand_less_outlined : Icons.expand_more_outlined,
                    color: Colors.blueGrey,
                  ),
                  onTap: () {
                    setState(() {
                      _expandedItems[resource.id] = !isExpanded;
                    });
                  },
                ),
                AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.all(16).copyWith(top: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: Colors.grey,),
                          const SizedBox(height: 12,),
                          Text(
                            'Описание',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Text(resource.description),
                          const SizedBox(height: 16,),
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 16, color: Colors.grey,),
                              const SizedBox(width: 4,),
                              Text(
                                resource.author,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const Spacer(),
                              Text(
                                resource.date,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                ),
              ],
            ),
          );
        }
    );
  }
}
