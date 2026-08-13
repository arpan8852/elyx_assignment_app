// lib/features/transactions/presentation/pages/transaction_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionEntity transaction;
  const TransactionDetailPage({super.key, required this.transaction});

  Color _statusColor() {
    switch (transaction.status) {
      case TransactionStatus.success:
        return Colors.green;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.pending:
        return Colors.orange;
    }
  }

  IconData _statusIcon() {
    switch (transaction.status) {
      case TransactionStatus.success:
        return Icons.check_circle;
      case TransactionStatus.failed:
        return Icons.cancel;
      case TransactionStatus.pending:
        return Icons.access_time_filled;
    }
  }

  String _statusText() {
    switch (transaction.status) {
      case TransactionStatus.success:
        return 'SUCCESS';
      case TransactionStatus.failed:
        return 'FAILED';
      case TransactionStatus.pending:
        return 'PENDING';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: _statusColor().withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _statusColor().withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(_statusIcon(), color: _statusColor(), size: 48),
                  const SizedBox(height: 12),
                  Text(
                    currencyFormat.format(transaction.amount),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Transaction Information',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Transaction ID',
                    value: transaction.id,
                    icon: Icons.tag,
                  ),
                  const Divider(height: 1),
                  _DetailRow(
                    label: 'Date',
                    value: transaction.date,
                    icon: Icons.calendar_today_outlined,
                  ),
                  const Divider(height: 1),
                  _DetailRow(
                    label: 'Amount',
                    value: currencyFormat.format(transaction.amount),
                    icon: Icons.currency_rupee,
                  ),
                  const Divider(height: 1),
                  _DetailRow(
                    label: 'Merchant',
                    value: transaction.merchant,
                    icon: Icons.store_outlined,
                  ),
                  const Divider(height: 1),
                  _DetailRow(
                    label: 'Status',
                    value: _statusText(),
                    icon: Icons.info_outline,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transaction.description.isEmpty
                    ? 'No description available'
                    : transaction.description,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
