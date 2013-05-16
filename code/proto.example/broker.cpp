#include <string>
#include <iostream>
#include <stdexcept>
#include <unistd.h>
#include <zmq.hpp>
#include <order.pb.h>
#include <fill.pb.h>


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
    //std::cout << o.symbol() << "|" << o.price << "|" << o.size() << std::endl;
    std::string symbol(o.symbol());
    std::cout << symbol << std::endl;

    // send fill to client
    tutorial::Fill f;
    f.set_timestamp(1);
    f.set_symbol("ZMQ");
    f.set_price(55.59);
    f.set_size(100);

    zmq::message_t reply (f.ByteSize());
    if(!f.SerializeToArray(reply.data(),reply.size())) {
      throw std::logic_error("unable to SerializeToArray.");
    }
    socket.send(reply);
  }
  return 0;
}
