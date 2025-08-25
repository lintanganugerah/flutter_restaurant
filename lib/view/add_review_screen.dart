import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/view/detail_screen.dart';
import 'package:restaurant_flutter/viewModel/review_view_model.dart';
import 'package:restaurant_flutter/widgets/title_medium.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({
    super.key,
    required this.id,
    required this.restaurantName,
  });

  final String id;
  final String restaurantName;

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formControllerName = TextEditingController();
  final _formControllerReview = TextEditingController();

  late final ReviewViewModel _viewModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<ReviewViewModel>(context, listen: false);
    _viewModel.addListener(_handleStateChange);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_handleStateChange);
    _formControllerName.dispose();
    _formControllerReview.dispose();
    super.dispose();
  }

  void _handleStateChange() {
    if (!mounted) return;
    switch (_viewModel.resultReview) {
      case ResultReviewLoaded():
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return DetailScreen(id: widget.id);
                },
              ),
            );
          }
        });
        break;
      case ResultReviewError(message: final msg):
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $msg'), backgroundColor: Colors.red),
        );
        break;
      default:
        break;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final nameData = _formControllerName.text.trim();
      final reviewData = _formControllerReview.text.trim();
      _viewModel.postReview(
        restaurantId: widget.id,
        name: nameData,
        review: reviewData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.white.withValues(alpha: 0.7),
              child: BackButton(color: Colors.black54),
            ),
          ),
        ),
        title: const Text("Tambah Review", style: TextStyle(fontSize: 12)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Review Untuk Restoran:", style: textTheme.bodySmall),
              TitleMedium(text: widget.restaurantName),
              SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama"),
                    TextFormField(
                      controller: _formControllerName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),

                    Text("Review"),
                    TextFormField(
                      controller: _formControllerReview,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Review tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Kirim Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
