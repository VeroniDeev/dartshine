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

String methodToString(Method method) {
  String result = '';

  switch (method) {
    case Method.get:
      result = 'GET';
      break;
    case Method.post:
      result = 'POST';
      break;
    case Method.head:
      result = 'HEAD';
      break;
    case Method.put:
      result = 'PUT';
      break;
    case Method.delete:
      result = 'DELETE';
      break;
    case Method.connect:
      result = 'CONNECT';
      break;
    case Method.option:
      result = 'OPTION';
      break;
    case Method.trace:
      result = 'TRACE';
      break;
    case Method.patch:
      result = 'PATCH';
      break;
    case Method.unknow:
      result = '';
      break;
  }
  return result;
}
