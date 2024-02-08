import 'package:flutter/material.dart';

class IconsListModel {
  late Map iconsList;

  IconsListModel() {
    iconsList = {
      'Compras': Icons.shopping_cart,
      'Pagamentos': Icons.payments,
      'Faturas': Icons.show_chart,
      'Água': Icons.water_drop_sharp,
      'Energia': Icons.electric_bolt_outlined,
      'Gasolina': Icons.gas_meter_outlined,
      'Alimentação': Icons.food_bank_outlined,
      'Cartão de Crédito': Icons.credit_card,
      'Dados Móveis': Icons.four_g_plus_mobiledata_outlined,
      'Internet': Icons.wifi,
      'Infantil': Icons.crib,
      'Escola': Icons.school_outlined,
      'Gastos de Operação': Icons.storefront,
      'Bebidas': Icons.emoji_food_beverage_outlined,
      'Refeição': Icons.brunch_dining_outlined,
      'Games': Icons.gamepad_outlined,
      'Eletrônicos': Icons.speaker_group_sharp,
      'Hardware': Icons.computer,
      'Lavanderia': Icons.local_laundry_service_outlined,
      'Ar Condicionado': Icons.ac_unit,
      'Aquecimento': Icons.thermostat_outlined,
      'Diversão': Icons.beach_access_outlined,
      'Shows, Concertos, Teatro e Cinema': Icons.music_note_outlined,
      'Serviços Médicos': Icons.medical_services_outlined,
      'Ferramentas': Icons.hardware_outlined,
      'Gastos da Casa': Icons.house_outlined,
      'Produtos pro Quarto': Icons.bed_outlined,
      'Produtos pra Sala': Icons.chair_outlined,
      'Produtos pro Banheiro': Icons.bathtub_sharp,
      'Manutenção Verde': Icons.grass_outlined,
      'Negócios': Icons.business_outlined,
      'Construção': Icons.build,
      'Manutenção do Veículo': Icons.car_crash_outlined,
      'Presentes': Icons.card_giftcard_outlined,
      'Obras': Icons.carpenter_outlined,
      'Diversas': Icons.category_outlined,
      'Transporte': Icons.emoji_transportation_outlined,
      'Locomoção de Metrô': Icons.directions_subway_filled_outlined,
      'Locomoção de Ônibus': Icons.directions_bus_filled_outlined,
      'Locomoção de Bicicleta': Icons.directions_bike_outlined,
      'Locomoção de Barco': Icons.directions_boat_filled_outlined,
      'Locomoção de Carro': Icons.directions_car_filled_outlined,
    };
  }
  Map<dynamic, dynamic> get getList {
    return iconsList;
  }
}
