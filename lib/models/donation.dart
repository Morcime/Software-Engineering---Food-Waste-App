class Donation {
  final String id;
  final String foodName;
  final String description;
  final int quantity;
  final String imageUrl;
  final String donorId;
  final String? organizationId;
  final DateTime donationTime;
  bool isTaken;

  Donation({
    required this.id,
    required this.foodName,
    required this.description,
    required this.quantity,
    required this.imageUrl,
    required this.donorId,
    this.organizationId,
    required this.donationTime,
    this.isTaken = false,
  });
}