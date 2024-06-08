enum Method {
  get,
  post,
  head,
  put,
  delete,
  connect,
  option,
  trace,
  patch,
  unknow
}

Method methodWithString(String method) {
  Method result = Method.unknow;

  switch (method) {
    case 'GET':
      result = Method.get;
      break;
    case 'POST':
      result = Method.post;
      break;
    case 'HEAD':
      result = Method.head;
      break;
    case 'PUT':
      result = Method.put;
      break;
    case 'DELETE':
      result = Method.delete;
      break;
    case 'CONNECT':
      result = Method.connect;
      break;
    case 'OPTION':
      result = Method.option;
      break;
    case 'TRACE':
      result = Method.trace;
      break;
    case 'PATCH':
      result = Method.patch;
      break;
  }
  return result;
}
