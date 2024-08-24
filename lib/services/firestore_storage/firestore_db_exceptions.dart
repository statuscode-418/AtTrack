class FirestoreDBExceptions implements Exception {
  final String? message;
  final String? details;

  const FirestoreDBExceptions({
    this.message,
    this.details,
  });
}

class CouldNotCreateUserException extends FirestoreDBExceptions {
  CouldNotCreateUserException({
    super.message,
    super.details,
  });
}

class CouldNotGetAllUsersException extends FirestoreDBExceptions {
  CouldNotGetAllUsersException({
    super.message,
    super.details,
  });
}

class CouldNotGetUserException extends FirestoreDBExceptions {
  CouldNotGetUserException({
    super.message,
    super.details,
  });
}

class CouldNotUpdateUserException extends FirestoreDBExceptions {
  CouldNotUpdateUserException({
    super.message,
    super.details,
  });
}

class CouldNotDeleteUserException extends FirestoreDBExceptions {
  CouldNotDeleteUserException({
    super.message,
    super.details,
  });
}

class GenericDbException extends FirestoreDBExceptions {
  GenericDbException(String message) : super(message: message);

  @override
  String toString() => message ?? 'GenericDbException';
}
