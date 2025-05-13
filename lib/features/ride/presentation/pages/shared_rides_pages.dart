import 'package:domochat/features/ride/data/models/ride_model.dart';
import 'package:domochat/features/ride/presentation/bloc/ride_bloc.dart';
import 'package:domochat/features/ride/presentation/bloc/ride_event.dart';
import 'package:domochat/features/ride/presentation/bloc/ride_state.dart';
import 'package:domochat/features/ride/presentation/pages/shared_ride_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharedRidesPages extends StatefulWidget {
  final String communityId;
  const SharedRidesPages({super.key, required this.communityId});

  @override
  State<SharedRidesPages> createState() => _SharedRidesPagesState();
}

class _SharedRidesPagesState extends State<SharedRidesPages> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RideBloc>(context)
      .add(FetchRides(communityId: widget.communityId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Совместные поездки'),
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: Colors.blueGrey[300],
      body: BlocBuilder<RideBloc,RideState>(
        builder: (context, state) {
          if (state is RideLoadingState) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (state is RideLoadedState) {
            if (state.rides.isEmpty) {
              return const Center(
                child: Text('Пока нет активных запросов на поездку'),
              );
            }
            return _buildList(state.rides as List<RideModel>);
          } else if (state is RideErrorState) {
            return Center(child: Text('Ошибка: ${state.message}'),);
          }
          return const SizedBox.shrink();
        },
      )
    );
  }

  Widget _buildList(List<RideModel> rides) {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rides.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SharedRideDetailPage(ride: rides[index]),
              ),
            );
          },
          child: _SharedRideCard(ride: rides[index]),
        )
    );
  }
}

class _SharedRideCard extends StatelessWidget {
  final RideModel ride;

  const _SharedRideCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      //color: Colors.blueGrey[300],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRouteSection(),
            const SizedBox(height: 20,),
            _buildDateTimeSection(),
            const SizedBox(height: 16,),
            _buildAuthorSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.directions_car_filled_outlined,
            color: Colors.blue[800],
            size: 28,
          ),
          const SizedBox(width: 12,),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationText(ride.departureCity, ride.departureStreet, ride.departureHouse, Icons.my_location_outlined),
                  const SizedBox(height: 4,),
                  Center(child: Icon(Icons.arrow_downward_outlined,  size: 18, color: Colors.blueGrey[700],)),
                  _buildLocationText(ride.arrivalCity, ride.arrivalStreet, ride.arrivalHouse, Icons.location_on_outlined),
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget _buildLocationText(String city, String street, String house, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey[700],),
        const SizedBox(width: 8,),
        Expanded(
            child: Text(
              '$city, $street, $house,',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            )
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 28,
            color:  Colors.blue[800],
          ),
          const SizedBox(width: 16,),
          Text(
            ride.departureTime.substring(0, 10),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8,),
          Text(
            ride.departureTime.substring(11, 16),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage("images/icon_logo_2.png"),
            foregroundColor: Colors.blue[800],
          ),
          const SizedBox(width: 12,),
          Text(
            ride.authorName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
