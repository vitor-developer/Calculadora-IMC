import 'package:flutter/material.dart';

class IMCCalculatorPage extends StatefulWidget {
  @override
  _IMCCalculatorPageState createState() => _IMCCalculatorPageState();
}

class _IMCCalculatorPageState extends State<IMCCalculatorPage> with SingleTickerProviderStateMixin {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _result = "";
  String _imcStatus = "";
  Color _statusColor = Colors.blue;  // Cor inicial do status

  AnimationController? _animationController;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _calculateIMC() {
    // Substituindo a vírgula por ponto para converter corretamente
    String weightInput = _weightController.text.replaceAll(',', '.');
    String heightInput = _heightController.text.replaceAll(',', '.');

    double weight = double.parse(weightInput);
    double height = double.parse(heightInput);
    double imc = weight / (height * height);

    setState(() {
      _result = "Seu IMC é: ${imc.toStringAsFixed(2)}";

      // Atualizando o status e a cor com base na classificação do IMC
      if (imc < 18.6) {
        _imcStatus = "Abaixo do Peso";
        _statusColor = Colors.blue;  // Azul para Abaixo do Peso
      } else if (imc >= 18.5 && imc < 22.9) {
        _imcStatus = "Normal";
        _statusColor = Colors.green;  // Verde para Normal
      } else if (imc >= 23 && imc < 24.9) {
        _imcStatus = "Risco de Sobrepeso";
        _statusColor = Colors.yellow;  // Amarelo para Risco de Sobrepeso
      } else if (imc >= 25 && imc < 29.9) {
        _imcStatus = "Sobrepeso";
        _statusColor = Colors.orange;  // Laranja para Sobrepeso
      } else {
        _imcStatus = "Obesidade";
        _statusColor = Colors.redAccent;  // Vermelho Carmesim para Obesidade
      }

      // Disparando a animação
      _animationController!.forward().then((value) => _animationController!.reverse());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculo do IMC'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Cálculo do IMC",
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            Text(
              "Descubra seu Índice de Massa Corporal",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),

            // Campos de texto para Peso e Altura
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100.0,
                  child: TextField(
                    controller: _weightController,
                    decoration: InputDecoration(labelText: 'Peso (kg)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 100.0,
                  child: TextField(
                    controller: _heightController,
                    decoration: InputDecoration(labelText: 'Altura (m)', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Botão de calcular com animação
            ScaleTransition(
              scale: _scaleAnimation!,
              child: ElevatedButton(
                onPressed: _calculateIMC,
                child: Text(
                  'Calcular IMC',
                  style: TextStyle(fontSize: 20.0),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Resultado do cálculo
            Text(
              _result,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),

            // Status do IMC com cor variável
            Text(
              _imcStatus,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: _statusColor,  // Cor do texto alterada de acordo com a classificação
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Imagem ilustrativa
            Expanded(
              child: Image.asset(
                'assets/imc_fundo.png', 
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
