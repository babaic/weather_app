class Weather {
  final String id;
  final String city;
  final String country;
  final DateTime date;
  final double temperature;
  final dynamic humidity;
  final dynamic wind;
  final dynamic pressure;
  final dynamic cloudiness;
  final String icon;
  final String description;
  final bool isFavorite;

  Weather({
      this.id,
      this.city,
      this.country,
      this.date,
      this.temperature,
      this.humidity,
      this.wind,
      this.pressure,
      this.cloudiness,
      this.icon,
      this.description,
      this.isFavorite = false});
}
