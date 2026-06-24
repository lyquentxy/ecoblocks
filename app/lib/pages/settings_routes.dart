import 'package:ecoblocks_core/ecoblocks_core.dart';
import 'package:flutter/material.dart';

import '../controllers/hub_controller.dart';
import '../l10n/app_localizations.dart';
import '../settings/app_settings.dart';
import '../settings/local_env.dart';

class SettingsShellPage extends StatelessWidget {
  final HubController controller;
  final String routeName;

  const SettingsShellPage({
    required this.controller,
    required this.routeName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final child = switch (routeName) {
      '/settings/llm' => LlmSettingsPage(controller: controller),
      '/settings/test' => SettingsTestPage(controller: controller),
      _ => SettingsHomePage(controller: controller),
    };

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Container(color: Colors.black.withValues(alpha: 0.18)),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SafeArea(
            child: Material(
              elevation: 12,
              color: Theme.of(context).colorScheme.surface,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SizedBox.expand(child: child),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsHomePage extends StatelessWidget {
  final HubController controller;

  const SettingsHomePage({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = controller.settings;

    return _SettingsScaffold(
      title: l10n.settingsTitle,
      onClose: () => Navigator.of(context).popUntil((route) => route.isFirst),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.languageLabel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: '', label: Text(l10n.languageSystem)),
              ButtonSegment(value: 'zh', label: Text(l10n.languageChinese)),
              ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
            ],
            selected: {settings.localeCode},
            onSelectionChanged: (value) {
              controller.saveSettings(
                settings.copyWith(localeCode: value.first),
              );
            },
          ),
          const SizedBox(height: 28),
          _SettingsNavTile(
            icon: Icons.auto_awesome,
            title: l10n.llmSettingsTitle,
            subtitle: l10n.llmSettingsSubtitle,
            onTap: () => Navigator.of(context).pushReplacementNamed('/settings/llm'),
          ),
          const SizedBox(height: 12),
          _SettingsNavTile(
            icon: Icons.network_check,
            title: l10n.testLayerTitle,
            subtitle: l10n.testLayerSubtitle,
            onTap: () => Navigator.of(context).pushReplacementNamed('/settings/test'),
          ),
        ],
      ),
    );
  }
}

class LlmSettingsPage extends StatefulWidget {
  final HubController controller;

  const LlmSettingsPage({required this.controller, super.key});

  @override
  State<LlmSettingsPage> createState() => _LlmSettingsPageState();
}

class _LlmSettingsPageState extends State<LlmSettingsPage> {
  late final TextEditingController _keyController;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(
      text: widget.controller.settings.deepSeekApiKey,
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await widget.controller.saveSettings(
      widget.controller.settings.copyWith(
        deepSeekApiKey: _keyController.text.trim(),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).settingsSaved)),
    );
  }

  Future<void> _clear() async {
    _keyController.clear();
    await widget.controller.saveSettings(
      widget.controller.settings.copyWith(deepSeekApiKey: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SettingsScaffold(
      title: l10n.llmSettingsTitle,
      onBack: () => Navigator.of(context).pushReplacementNamed('/settings'),
      onClose: () => Navigator.of(context).popUntil((route) => route.isFirst),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.deepSeekFixedProvider),
          const SizedBox(height: 16),
          TextField(
            controller: _keyController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: l10n.deepSeekKey,
              hintText: l10n.apiKeyHint,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: _obscure ? l10n.showSecret : l10n.hideSecret,
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: Text(l10n.save),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: _clear,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.clear),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.envLocalHint),
        ],
      ),
    );
  }
}

class SettingsTestPage extends StatefulWidget {
  final HubController controller;

  const SettingsTestPage({required this.controller, super.key});

  @override
  State<SettingsTestPage> createState() => _SettingsTestPageState();
}

class _SettingsTestPageState extends State<SettingsTestPage> {
  bool _testing = false;
  DeepSeekConnectionTestResult? _result;

  String get _apiKey {
    final saved = widget.controller.settings.deepSeekApiKey.trim();
    if (saved.isNotEmpty) return saved;
    return LocalEnv.deepSeekApiKey.trim();
  }

  Future<void> _testDeepSeek() async {
    final l10n = AppLocalizations.of(context);
    final apiKey = _apiKey;
    if (apiKey.isEmpty) {
      setState(() {
        _result = DeepSeekConnectionTestResult(
          success: false,
          message: l10n.missingApiKey,
        );
      });
      return;
    }

    setState(() {
      _testing = true;
      _result = null;
    });

    final agent = DeepSeekAgent(config: DeepSeekConfig(apiKey: apiKey));
    final result = await agent.testConnection();
    if (!mounted) return;
    setState(() {
      _testing = false;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final result = _result;

    return _SettingsScaffold(
      title: l10n.testLayerTitle,
      onBack: () => Navigator.of(context).pushReplacementNamed('/settings'),
      onClose: () => Navigator.of(context).popUntil((route) => route.isFirst),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.deepSeekConnectionTestDescription),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _testing ? null : _testDeepSeek,
            icon: _testing
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.network_check),
            label: Text(_testing ? l10n.testing : l10n.testConnection),
          ),
          if (result != null) ...[
            const SizedBox(height: 20),
            _TestResultBanner(result: result),
          ],
        ],
      ),
    );
  }
}

class _SettingsScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onBack;
  final VoidCallback onClose;

  const _SettingsScaffold({
    required this.title,
    required this.child,
    required this.onClose,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 64,
          child: Row(
            children: [
              if (onBack != null)
                IconButton(
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBack,
                )
              else
                const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsNavTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      onTap: onTap,
    );
  }
}

class _TestResultBanner extends StatelessWidget {
  final DeepSeekConnectionTestResult result;

  const _TestResultBanner({required this.result});

  @override
  Widget build(BuildContext context) {
    final color = result.success ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(result.success ? Icons.check_circle : Icons.error_outline,
              color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(result.message)),
        ],
      ),
    );
  }
}
