class Food {
  String nombre;
  double precio;
  String descripcion;
  String img;

  Food(this.nombre, this.precio, this.descripcion, this.img);

  Food.fromJson(Map<dynamic,dynamic> json){
    this.nombre = json['nombre'];
    this.descripcion = json['descripcion'];
    this.precio = json['precio'];
    this.img = json['img'];
  }
}
