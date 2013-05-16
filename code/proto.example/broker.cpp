#include <string>
#include <iostream>
#include <stdexcept>
#include <unistd.h>
#include <zmq.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <order.pb.h>
#include <fill.pb.h>
using namespace boost::posix_time;
using std::cout; using std::endl;

int main () {
  zmq::context_t context(1);
  zmq::socket_t socket (context, ZMQ_REP);
  socket.bind ("tcp://*:5559");

  while (true) {
    //  wait for order
    zmq::message_t request;
    socket.recv(&request);

    tutorial::Order o;
    o.ParseFromArray(request.data(), request.size());

    std::string symbol(o.symbol());
    double price(o.price());
    int size(o.size());

    // send fill to client
    tutorial::Fill f;
    f.set_timestamp(to_simple_string(second_clock::universal_time()));
    f.set_symbol(symbol); f.set_price(price); f.set_size(size);

    zmq::message_t reply (f.ByteSize());
    if(!f.SerializeToArray(reply.data(),reply.size())) {
      throw std::logic_error("unable to SerializeToArray.");
    }
    socket.send(reply);
  }
  return 0;
}
