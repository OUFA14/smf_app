import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '../../services/auth_service.dart';
import '../../services/users_service.dart';


class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  bool _isEditing = false;
  final UsersService _usersService = UsersService();

  // ── Basic Details ────────────────────────────────────────────────────────
  final _fullNameCtrl = TextEditingController(text: "");
  final _emailCtrl = TextEditingController(text: "");
  bool _isLoading = false;  
  String _selectedGender = "Prefer not to say";
  final List<String> _genders = ["Male", "Female", "Prefer not to say"];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userId = AuthService.instance.userId;
    if (userId == null || userId.isEmpty) return;

    try {
      final user = await _usersService.getUser(userId);
      if (!mounted) return;
      setState(() {
        _fullNameCtrl.text =
            user.name.trim().isEmpty ?  : user.name;
        _emailCtrl.text =
            user.email.trim().isEmpty ?  : user.email;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

    Future<void> _toggleEdit() async {
    if (_isEditing) {
      final userId = AuthService.instance.userId;
      if (userId == null || userId.isEmpty) return;

      setState(() => _isLoading = true);

      try {
        await _usersService.updateUser(
          id: userId,
          username: _fullNameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: null,
          roles: {_currentUser?.role ?? 'ROLE_USER'},
          phone: _phoneCtrl.text.trim(),
          nationalId: _nationalIdCtrl.text.trim(),
          dateOfBirth: _dobCtrl.text.trim(),
          gender: _selectedGender,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.read<LanguageProvider>().getText('personalInformationSaved')),
            backgroundColor: Colors.green.shade700,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
    setState(() => _isEditing = !_isEditing);
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
  return const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
}
    final themeProvider = context.watch<ThemeProvider>();
    final lang = context.watch<LanguageProvider>();
    final isDark = themeProvider.isDarkMode;
    final bgColor = isDark ? const Color(0xFF0A1628) : const Color(0xFFF4F6FA);
    final cardColor = isDark ? const Color(0xFF111C30) : Colors.white;
    final borderColor =
        isDark ? Colors.white.withOpacity(0.07) : Colors.grey.withOpacity(0.15);

    return Directionality(
      textDirection: lang.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF0A1628) : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            lang.isArabic ? "المعلومات الشخصية" : "Personal Information",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: _toggleEdit,
                icon: Icon(
                  _isEditing ? Icons.check : Icons.edit_outlined,
                  size: 18,
                  color: _isEditing ? Colors.green : Colors.blueAccent,
                ),
                label: Text(
                  _isEditing
                      ? (lang.isArabic ? "حفظ" : "Save")
                      : (lang.isArabic ? "تعديل" : "Edit"),
                  style: TextStyle(
                    color: _isEditing ? Colors.green : Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Basic Details ────────────────────────────────────────
              _sectionHeader(
                isDark,
                icon: Icons.person_outline,
                label: lang.isArabic ? "البيانات الأساسية" : "Basic Details",
              ),
              const SizedBox(height: 12),
              _card(cardColor, borderColor, [
  _field(isDark,
      label: lang.isArabic ? "الاسم الكامل" : "Full Name",
      ctrl: _fullNameCtrl,
      icon: Icons.badge_outlined),
  _genderRow(isDark, label: lang.isArabic ? "الجنس" : "Gender"),
  _field(isDark,
      label: lang.isArabic ? "البريد الإلكتروني" : "Email",
      ctrl: _emailCtrl,
      icon: Icons.email_outlined,
      type: TextInputType.emailAddress),
]),

              const SizedBox(height: 28),

              if (_isEditing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _toggleEdit,
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: Text(
                      lang.isArabic ? "حفظ التغييرات" : "Save Changes",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionHeader(bool isDark,
      {required IconData icon,
      required String label,
      Color accent = Colors.blueAccent}) {
    return Row(children: [
      Icon(icon, color: accent, size: 18),
      const SizedBox(width: 8),
      Text(label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          )),
    ]);
  }

  Widget _card(Color cardColor, Color borderColor, List<Widget> children) {
    final divider =
        Divider(height: 1, color: borderColor, indent: 16, endIndent: 16);
    final rows = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i < children.length - 1) rows.add(divider);
    }
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: rows),
    );
  }

  Widget _field(
    bool isDark, {
    required String label,
    required TextEditingController ctrl,
    required IconData icon,
    TextInputType type = TextInputType.text,
  }) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white38 : Colors.black38;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(children: [
        Icon(icon, size: 18, color: subColor),
        const SizedBox(width: 12),
        Expanded(
          child: _isEditing
              ? TextField(
                  controller: ctrl,
                  keyboardType: type,
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(color: subColor, fontSize: 12),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(color: subColor, fontSize: 11)),
                      const SizedBox(height: 3),
                      Text(
                        ctrl.text.isEmpty ? "—" : ctrl.text,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
        ),
        if (_isEditing)
          Icon(Icons.edit,
              size: 14, color: isDark ? Colors.white24 : Colors.black26),
      ]),
    );
  }

  Widget _genderRow(bool isDark, {required String label}) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white38 : Colors.black38;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(children: [
        Icon(Icons.people_outline, size: 18, color: subColor),
        const SizedBox(width: 12),
        Expanded(
          child: _isEditing
              ? DropdownButtonFormField<String>(
                  value: _selectedGender,
                  dropdownColor:
                      isDark ? const Color(0xFF111C30) : Colors.white,
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(color: subColor, fontSize: 12),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  items: _genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedGender = val);
                  },
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(color: subColor, fontSize: 11)),
                      const SizedBox(height: 3),
                      Text(_selectedGender,
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
        ),
        if (_isEditing)
          Icon(Icons.edit,
              size: 14, color: isDark ? Colors.white24 : Colors.black26),
      ]),
    );
  }
}
