import 'package:domochat/features/trip/data/models/trip_request.dart';
import 'package:flutter/material.dart';

class TripRequestsPage extends StatelessWidget {
  TripRequestsPage({super.key});

  final List<TripRequest> _requests = [
    TripRequest(
      from: 'Москва, ул.Пушкина',
      to: 'Москва, ул. Ленина',
      date: '10 мая 2025',
      time: '08:00',
      authorName: 'Иван',
      authorRating: 5.0,
    ),
    TripRequest(
      from: 'Ярославль, ул.Дачная',
      to: 'Ярославль, ул. Ломоносова',
      date: '11 мая 2025',
      time: '07:00',
      authorName: 'Дмитрий',
      authorRating: 4.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Совместные поездки'),
        centerTitle: true,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _requests.length,
          itemBuilder: (context, index) {
            final request = _requests[index];
            return _TripRequestCard(request: request);
          }
      ),
    );
  }
}

class _TripRequestCard extends StatelessWidget {
  final TripRequest request;

  const _TripRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRouteSection(),
            const SizedBox(height: 16,),
            _buildDateTimeSection(),
            const SizedBox(height: 16,),
            _buildAuthorSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSection() {
    return Row(
      children: [
         Icon(
          Icons.location_on_outlined,
          color: Colors.blue[500],
          size: 30,
        ),
        const SizedBox(width: 8,),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.from,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4,),
                Icon(
                  Icons.arrow_downward_outlined,
                  color: Colors.grey[800],
                  size: 16,
                ),
                const SizedBox(height: 4,),
                Text(
                  request.to,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Row(
      children: [
        Icon(
          Icons.access_time_outlined,
          color: Colors.grey[800],
          size: 30,
        ),
        const SizedBox(width: 8,),
        Text(
          '${request.date} • ${request.time}',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blue,
          child: Text(
            request.authorName[0],
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
        const SizedBox(width: 8,),
        Text(
          request.authorName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8,),
        Icon(
          Icons.star_border_outlined,
          color: Colors.amber[600],
          size: 16,
        ),
        Text(
          request.authorRating.toString(),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
