import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';

void main() => runApp(MaterialApp(home: QuoteList()));

class QuoteList extends StatefulWidget {
  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<Quote> quotes = [
    Quote(
      author: 'Oscar Wilde',
      text: 'Be yourself; everyone else is already taken',
    ),
    Quote(
      author: 'Oscar Wilde',
      text: 'I have nothing to declare except my genius',
    ),
    Quote(
      author: 'Oscar Wilde',
      text: 'The truth is rarely pure and never simple',
    ),
  ];

  void _addQuote(String author, String text) {
    setState(() {
      quotes.add(Quote(author: author, text: text));
    });
  }

  void _updateQuote(int index, String newAuthor, String newText) {
    setState(() {
      quotes[index] = Quote(author: newAuthor, text: newText);
    });
  }

  void _deleteQuote(Quote quote) {
    setState(() {
      quotes.remove(quote);
    });
  }

  void _editQuoteDialog(int index) {
    TextEditingController _authorController = TextEditingController(
      text: quotes[index].author,
    );
    TextEditingController _textController = TextEditingController(
      text: quotes[index].text,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Quote'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'New Author'),
              ),
              TextField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'New Quote'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateQuote(
                  index,
                  _authorController.text,
                  _textController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: CustomHeader(title: 'Awesome Quotes'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          QuoteInput(onSubmit: _addQuote),
          Expanded(
            child: ListView(
              children:
                  quotes.asMap().entries.map((entry) {
                    int index = entry.key;
                    Quote quote = entry.value;
                    return QuoteCard(
                      quote: quote,
                      delete: () => _deleteQuote(quote),
                      edit: () => _editQuoteDialog(index),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomHeader extends StatelessWidget {
  final String title;
  const CustomHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class QuoteInput extends StatefulWidget {
  final Function(String, String) onSubmit;
  QuoteInput({required this.onSubmit});

  @override
  _QuoteInputState createState() => _QuoteInputState();
}

class _QuoteInputState extends State<QuoteInput> {
  final _authorController = TextEditingController();
  final _textController = TextEditingController();

  void _submitData() {
    if (_authorController.text.isEmpty || _textController.text.isEmpty) return;
    widget.onSubmit(_authorController.text, _textController.text);
    _authorController.clear();
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _authorController,
            decoration: InputDecoration(labelText: 'Author'),
          ),
          TextField(
            controller: _textController,
            decoration: InputDecoration(labelText: 'Quote'),
          ),
          SizedBox(height: 10),
          CustomButton(label: 'Add Quote', onPressed: _submitData),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}
