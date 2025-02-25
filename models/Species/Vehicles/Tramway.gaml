/**
* Name: Bus
* Based on the internal empty template. 
* Author: coohauterv
* Tags: 
*/

//This should not be a Person's vehicle as it is a public transport system

model Tramway

import "../Transports/TransportTrip.gaml"

import "Vehicle.gaml"

species Tramway parent: Vehicle schedules: [] {
	
	TransportTrip trip;
	int current_stop_idx <- 0;
	string next_stop ; //useful for debug
	
	init {
		seats <- 110;
	}
	
	
	action init_vehicle(Person _owner, float _length<-11.0#meter, float _speed<-90#km/#h, int _seats<-40){
		//_owner is to match the other vehicle classes, but a common transport doesnot need one
//		owner <- _owner; //random assignement, useless except to use get_current_date of Vehicle.gaml
//		length <- _length;
//		speed <- _speed;
//		seats <- _seats;	
	}
	
	action go_to_next_stop {
		//TODO remove edge from graph ?
		current_stop_idx <- current_stop_idx + 1;
		
		if current_stop_idx < length(trip.stops){
			next_stop <- trip.stops[current_stop_idx].real_name;
			
			do later the_action: "arrive_at_destination" at: trip.departure_times[current_stop_idx];
		}else{
			//we are in terminus
			if !empty(passengers) {
				write get_current_date() +  ": " + name + " has some passengers still inside even though we are in terminus! :" color:#red;
				PublicTransportCard tc;
				list<Person> get_out;
				
				loop p over: passengers {
					tc <- PublicTransportCard(p.current_vehicle);
		
					if last(trip.stops).real_name = tc.stops[tc.itinerary_idx].real_name {
						add p to: get_out;
					}
				}
				
				loop p over: get_out {			
					tc <- PublicTransportCard(p.current_vehicle);
					ask tc {
						do get_out;
					}
				}
			}
			ask trip {
				do end_trip;
			}
			do die;		
		}
	}
	
	path compute_path_between(point p1, point p2) {
		return path_between(car_road_graph, p1, p2);
	}
	
	action take_passengers_out {
		PublicTransportCard tc;
		list<Person> get_out;

		loop p over: passengers {
			tc <- PublicTransportCard(p.current_vehicle);

			if trip.stops[current_stop_idx].real_name = tc.stops[tc.itinerary_idx].real_name {
				add p to: get_out;
				//write "This is just for test: " + name + " makes " + p.name + " go out";
			}
		}
		
		loop p over: get_out {			
			tc <- PublicTransportCard(p.current_vehicle);
			ask tc {
				do get_out;
			}
		}
	}
	
	action take_passengers_in {
		PublicTransportCard tc;
		list<Person> new_passengers;
		ask trip.stops[current_stop_idx] {
			new_passengers <- get_waiting_persons(myself);
		}
		
		loop p over: new_passengers {
			tc <- PublicTransportCard(p.current_vehicle);
			ask tc {
				do get_in(myself);
			}
		}
		//remove edge from graph
//		if current_stop_idx < length(trip.my_edges) and Constants[0].dynamic_public_transport_graph {
//			ask trip.my_edges[current_stop_idx] {
//				do die;	
//			}
//		}
	}
	
	action goto(point dest){
		//leave this fct even tho it is not used because of the interface Vehicle.gaml
		write "The method goto() on a common transport should not be called! \n go_to_next_stop() is used instead" color:#red;
	}
	
	action propose {
		write "The methof: propose() should not be called on a tramway agent: " + name color:#red;
	}
	
	action enter_road(Road road){
		//
		write "The method: enter_road() should not be called on a tramway agent: " + name color:#red;
	}
	
	action arrive_at_destination {		
		do move_to(trip.stops[current_stop_idx].location);
		
		do take_passengers_out;
		if current_stop_idx < length(trip.stops){
			do take_passengers_in;	
		}	
//		if get_current_date() >= trip.departure_times[current_stop_idx] {
//			do go_to_next_stop;
//		}else{
//			do later the_action: "go_to_next_stop" at:trip.departure_times[current_stop_idx];
//		}
		do go_to_next_stop;

	}
	
	aspect default {
		draw circle(20) color: color border: #black;
	}
}

