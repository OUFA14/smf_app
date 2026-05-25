import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../services/emergency_service.dart';
import '../../models/emergency_status.dart';
import '../../models/active_incident.dart';
import '../../models/incident_feed.dart';
import '../../models/emergency_personnel.dart';
import '../../models/emergency_contact.dart';
import '../../models/system_status.dart';
import '../../theme/app_theme.dart';

class EmergencyDashboardPage extends StatefulWidget {
  const EmergencyDashboardPage({super.key});

  @override
  State<EmergencyDashboardPage> createState() => _EmergencyDashboardPageState();
}

class _EmergencyDashboardPageState extends State<EmergencyDashboardPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  // Emergency Data
  EmergencyStatus? _emergencyStatus;
  ActiveIncident? _activeIncident;
  List<IncidentFeedItem> _incidentFeed = [];
  List<EmergencyPersonnel> _personnel = [];
  List<EmergencyContact> _contacts = [];
  SystemStatus? _systemStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _loadEmergencyData();
  }

  Future<void> _loadEmergencyData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        EmergencyService().getStatus(),
        EmergencyService().getActiveIncident(),
        EmergencyService().getIncidentFeed(),
        EmergencyService().getPersonnel(),
        EmergencyService().getContacts(),
        EmergencyService().getSystemStatus(),
      ]);
      if (!mounted) return;
      setState(() {
        _emergencyStatus = results[0] as EmergencyStatus;
        _activeIncident = results[1] as ActiveIncident;
        _incidentFeed = results[2] as List<IncidentFeedItem>;
        _personnel = results[3] as List<EmergencyPersonnel>;
        _contacts = results[4] as List<EmergencyContact>;
        _systemStatus = results[5] as SystemStatus;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final palette = _EmergencyPalette(
      Theme.of(context).brightness == Brightness.dark,
    );
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [palette.page, palette.pageAlt],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 980;
          return Padding(
            padding: EdgeInsets.fromLTRB(20, compact ? 12 : 16, 20, 20),
            child: compact
                ? _CompactEmergencyBody(
                    palette: palette,
                    pulseController: _pulseController,
                    emergencyStatus: _emergencyStatus,
                    activeIncident: _activeIncident,
                    incidentFeed: _incidentFeed,
                    personnel: _personnel,
                    contacts: _contacts,
                    systemStatus: _systemStatus,
                  )
                : _DesktopEmergencyBody(
                    palette: palette,
                    pulseController: _pulseController,
                    emergencyStatus: _emergencyStatus,
                    activeIncident: _activeIncident,
                    incidentFeed: _incidentFeed,
                    personnel: _personnel,
                    contacts: _contacts,
                    systemStatus: _systemStatus,
                  ),
          );
        },
      ),
    );
  }
}

class _DesktopEmergencyBody extends StatelessWidget {
  final _EmergencyPalette palette;
  final AnimationController pulseController;
  final EmergencyStatus? emergencyStatus;
  final ActiveIncident? activeIncident;
  final List<IncidentFeedItem> incidentFeed;
  final List<EmergencyPersonnel> personnel;
  final List<EmergencyContact> contacts;
  final SystemStatus? systemStatus;

  const _DesktopEmergencyBody({
    required this.palette,
    required this.pulseController,
    required this.emergencyStatus,
    required this.activeIncident,
    required this.incidentFeed,
    required this.personnel,
    required this.contacts,
    required this.systemStatus,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _EmergencyBanner(
            palette: palette,
            pulseController: pulseController,
            emergencyStatus: emergencyStatus,
          ),
          const SizedBox(height: 18),
          _StatsRow(
            palette: palette,
            emergencyStatus: emergencyStatus,
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 56,
                child: Column(
                  children: [
                    SizedBox(
                      height: 280,
                      child: _LiveMapCard(palette: palette),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 220,
                            child: _PersonnelCard(
                              palette: palette,
                              personnel: personnel,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: SizedBox(
                            height: 220,
                            child: _ContactsCard(
                              palette: palette,
                              contacts: contacts,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                flex: 50,
                child: Column(
                  children: [
                    SizedBox(
                      height: 260,
                      child: _ActiveIncidentCard(
                        palette: palette,
                        activeIncident: activeIncident,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 250,
                      child: _IncidentFeedCard(
                        palette: palette,
                        incidentFeed: incidentFeed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SystemStrip(
            palette: palette,
            systemStatus: systemStatus,
          ),
        ],
      ),
    );
  }
}

class _CompactEmergencyBody extends StatelessWidget {
  final _EmergencyPalette palette;
  final AnimationController pulseController;
  final EmergencyStatus? emergencyStatus;
  final ActiveIncident? activeIncident;
  final List<IncidentFeedItem> incidentFeed;
  final List<EmergencyPersonnel> personnel;
  final List<EmergencyContact> contacts;
  final SystemStatus? systemStatus;

  const _CompactEmergencyBody({
    required this.palette,
    required this.pulseController,
    required this.emergencyStatus,
    required this.activeIncident,
    required this.incidentFeed,
    required this.personnel,
    required this.contacts,
    required this.systemStatus,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _EmergencyBanner(
            palette: palette,
            pulseController: pulseController,
            emergencyStatus: emergencyStatus,
          ),
          const SizedBox(height: 14),
          _StatsRow(
            palette: palette,
            emergencyStatus: emergencyStatus,
          ),
          const SizedBox(height: 14),
          SizedBox(height: 250, child: _LiveMapCard(palette: palette)),
          const SizedBox(height: 14),
          SizedBox(
            height: 280,
            child: _ActiveIncidentCard(
              palette: palette,
              activeIncident: activeIncident,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 230,
            child: _IncidentFeedCard(
              palette: palette,
              incidentFeed: incidentFeed,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 220,
            child: _PersonnelCard(
              palette: palette,
              personnel: personnel,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 220,
            child: _ContactsCard(
              palette: palette,
              contacts: contacts,
            ),
          ),
          const SizedBox(height: 14),
          _SystemStrip(
            palette: palette,
            systemStatus: systemStatus,
          ),
        ],
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  final _EmergencyPalette palette;
  final AnimationController pulseController;
  final EmergencyStatus? emergencyStatus;

  const _EmergencyBanner({
    required this.palette,
    required this.pulseController,
    required this.emergencyStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = emergencyStatus?.mode == 'ACTIVE';
    final level = emergencyStatus?.level ?? 1;
    final timeElapsed = emergencyStatus?.timeElapsed ?? '00:00';

    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, _) {
        final glow = 0.18 + pulseController.value * 0.18;
        return Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                palette.redDark.withValues(alpha: 0.45),
                palette.card,
                palette.redDark.withValues(alpha: 0.36),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.red.withValues(alpha: 0.75)),
            boxShadow: [
              BoxShadow(
                color: palette.red.withValues(alpha: glow),
                blurRadius: 22,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: palette.red.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: palette.red.withValues(alpha: 0.85)),
                ),
                child: Icon(Icons.warning_amber_rounded,
                    color: palette.redHot, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isActive ? 'EMERGENCY MODE ACTIVE' : 'NORMAL MODE',
                      style: TextStyle(
                        color: palette.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isActive
                          ? 'Alert Level $level   •   Teams Notified'
                          : 'Monitoring Mode   •   All Systems Normal',
                      style: TextStyle(color: palette.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _BannerAction(
                palette: palette,
                icon: Icons.warning_amber_rounded,
                label: 'ALL UNITS RESPOND',
              ),
              _BannerAction(
                palette: palette,
                icon: Icons.local_fire_department_outlined,
                label: 'EMERGENCY SERVICES DISPATCHED',
              ),
              const SizedBox(width: 18),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Time Elapsed',
                      style: TextStyle(color: palette.muted, fontSize: 10)),
                  Text(
                    timeElapsed,
                    style: TextStyle(
                      color: palette.text,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              CustomPaint(
                size: const Size(72, 32),
                painter: _HeartbeatPainter(color: palette.redHot),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatsRow extends StatelessWidget {
  final _EmergencyPalette palette;
  final EmergencyStatus? emergencyStatus;

  const _StatsRow({
    required this.palette,
    required this.emergencyStatus,
  });

  @override
  Widget build(BuildContext context) {
    final zone = emergencyStatus?.zone ?? 'Zone 1';
    final responseTime = emergencyStatus?.responseTime ?? '2:34';
    final unitsDeployed = emergencyStatus?.unitsDeployed ?? 5;
    final status = emergencyStatus?.status ?? 'ACTIVE';

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 520
                ? 2
                : 1;
        const spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        final cards = [
          _StatSpec('Zone', zone, 'Location', LucideIcons.mapPin, palette.blue),
          _StatSpec('Response Time', responseTime, 'Minutes', LucideIcons.clock,
              palette.blue),
          _StatSpec('Units Deployed', '$unitsDeployed Units', 'Nearby', LucideIcons.users,
              palette.blue),
          _StatSpec('Status', status, 'All Systems Operational',
              LucideIcons.radio, status == 'ACTIVE' ? palette.red : palette.green),
        ];
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: cards
              .map((card) => SizedBox(
                    width: itemWidth,
                    height: 116,
                    child: _StatCard(palette: palette, spec: card),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _LiveMapCard extends StatelessWidget {
  final _EmergencyPalette palette;

  const _LiveMapCard({required this.palette});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      palette: palette,
      title: 'Live Situation Map',
      trailing: _MiniButton(palette: palette, label: 'View Full Map'),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  palette.page.withValues(alpha: 0.28),
                  BlendMode.srcATop,
                ),
                child: Image.asset(
                  'assets/images/isometric_factory_map.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _SituationMapPainter(palette: palette),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 10,
            child: Wrap(
              spacing: 18,
              runSpacing: 8,
              children: [
                _MapLegendDot('Incident Location', palette.red),
                _MapLegendDot('Units', palette.blue),
                _MapLegendDot('Personnel', palette.green),
                _MapLegendDot('Cameras', palette.gold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveIncidentCard extends StatelessWidget {
  final _EmergencyPalette palette;
  final ActiveIncident? activeIncident;

  const _ActiveIncidentCard({
    required this.palette,
    required this.activeIncident,
  });

  @override
  Widget build(BuildContext context) {
    final title = activeIncident?.title ?? 'Security Breach Detected';
    final location = activeIncident?.location ?? 'Main Entrance - Zone 1';
    final incidentId = activeIncident?.incidentId ?? 'INC-2025-0017';

    return _Panel(
      palette: palette,
      title: 'Active Incident',
      titleIcon: Icons.warning_amber_rounded,
      titleColor: palette.redHot,
      trailing: _PriorityPill(palette: palette),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: palette.redHot, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: palette.text,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style: TextStyle(color: palette.muted, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reported ${_formatTime(activeIncident?.reportedAt)}   •   Incident ID: $incidentId',
                      style: TextStyle(color: palette.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          _IncidentProgress(
            palette: palette,
            steps: activeIncident?.steps ?? [],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final suffix = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}

class _IncidentFeedCard extends StatelessWidget {
  final _EmergencyPalette palette;
  final List<IncidentFeedItem> incidentFeed;

  const _IncidentFeedCard({
    required this.palette,
    required this.incidentFeed,
  });

  @override
  Widget build(BuildContext context) {
    final events = incidentFeed.isEmpty
        ? [
            ('No events', 'No recent incidents', 'System', palette.muted, Icons.info_outline_rounded),
          ]
        : incidentFeed.map((item) => (
            item.time,
            item.description,
            item.location,
            _getColorForType(item.type, palette),
            _getIconForType(item.icon),
          )).toList();

    return _Panel(
      palette: palette,
      title: 'Incident Feed',
      trailing: _MiniButton(palette: palette, label: 'View All'),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: events.length,
        separatorBuilder: (_, __) => Divider(color: palette.line, height: 1),
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: event.$4.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(color: event.$4.withValues(alpha: 0.6)),
                  ),
                  child: Icon(event.$5, color: event.$4, size: 17),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 58,
                  child: Text(event.$1,
                      style: TextStyle(color: palette.muted, fontSize: 11)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.text,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        event.$3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: palette.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getColorForType(String type, _EmergencyPalette palette) {
    switch (type.toLowerCase()) {
      case 'emergency':
        return palette.red;
      case 'warning':
        return palette.gold;
      case 'info':
        return palette.blue;
      default:
        return palette.blue;
    }
  }

  IconData _getIconForType(String icon) {
    switch (icon.toLowerCase()) {
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'emergency':
        return Icons.sos_rounded;
      case 'info':
        return Icons.info_outline_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }
}

class _PersonnelCard extends StatelessWidget {
  final _EmergencyPalette palette;
  final List<EmergencyPersonnel> personnel;

  const _PersonnelCard({
    required this.palette,
    required this.personnel,
  });

  @override
  Widget build(BuildContext context) {
    final displayPersonnel = personnel.isEmpty
        ? [('JD', 'No Personnel', '--', palette.muted)]
        : personnel.map((p) => (
            p.initials,
            p.name,
            '${p.zone}  •  ${p.bpm} BPM',
            p.status == 'active' ? palette.red : palette.gold,
          )).toList();

    return _Panel(
      palette: palette,
      title: 'Emergency Personnel',
      trailing: _MiniButton(palette: palette, label: 'View All'),
      child: Column(
        children: [
          for (int i = 0; i < displayPersonnel.length && i < 2; i++) ...[
            if (i > 0) Divider(color: palette.line, height: 1),
            _PersonTile(
              palette: palette,
              initials: displayPersonnel[i].$1,
              name: displayPersonnel[i].$2,
              meta: displayPersonnel[i].$3,
              color: displayPersonnel[i].$4,
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactsCard extends StatelessWidget {
  final _EmergencyPalette palette;
  final List<EmergencyContact> contacts;

  const _ContactsCard({
    required this.palette,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    final displayContacts = contacts.isEmpty
        ? [('Emergency Services', '911', 'emergency')]
        : contacts.map((c) => (c.name, c.number, c.type)).toList();

    return _Panel(
      palette: palette,
      title: 'Emergency Contacts',
      trailing: _MiniButton(palette: palette, label: 'View All'),
      child: Column(
        children: [
          for (int i = 0; i < displayContacts.length && i < 2; i++) ...[
            if (i > 0) Divider(color: palette.line, height: 1),
            _ContactTile(
              palette: palette,
              icon: displayContacts[i].$3 == 'emergency'
                  ? Icons.call_rounded
                  : Icons.shield_rounded,
              title: displayContacts[i].$1,
              subtitle: displayContacts[i].$2,
            ),
          ],
        ],
      ),
    );
  }
}

class _SystemStrip extends StatelessWidget {
  final _EmergencyPalette palette;
  final SystemStatus? systemStatus;

  const _SystemStrip({
    required this.palette,
    required this.systemStatus,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      ('System Status', systemStatus?.systemStatus ?? 'Operational', Icons.wifi_rounded,
          systemStatus?.systemStatus == 'Operational' ? palette.green : palette.red),
      ('Communication', systemStatus?.communication ?? 'Encrypted', Icons.lock_outline_rounded, palette.muted),
      ('Weather', systemStatus?.weather ?? 'Clear, 28°C', Icons.wb_sunny_outlined, palette.gold),
      ('Network', systemStatus?.network ?? 'Stable', Icons.signal_cellular_alt_rounded, palette.green),
      ('Last Updated', systemStatus?.lastUpdated ?? '08:45:12 AM', Icons.refresh_rounded, palette.blue),
    ];
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: items[i].$4.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(items[i].$3, color: items[i].$4, size: 15),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[i].$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: palette.text,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          items[i].$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: items[i].$4, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (i != items.length - 1) VerticalDivider(color: palette.line),
          ],
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final _EmergencyPalette palette;
  final String title;
  final Widget child;
  final Widget? trailing;
  final IconData? titleIcon;
  final Color? titleColor;

  const _Panel({
    required this.palette,
    required this.title,
    required this.child,
    this.trailing,
    this.titleIcon,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: palette.shadow,
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (titleIcon != null) ...[
                Icon(titleIcon, color: titleColor ?? palette.blue, size: 18),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: palette.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _EmergencyPalette palette;
  final _StatSpec spec;

  const _StatCard({required this.palette, required this.spec});

  @override
  Widget build(BuildContext context) {
    final active = spec.value == 'ACTIVE';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: active ? palette.redDark.withValues(alpha: 0.32) : palette.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: active ? palette.red.withValues(alpha: 0.55) : palette.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: spec.color.withValues(alpha: 0.13),
              shape: BoxShape.circle,
              border: Border.all(color: spec.color.withValues(alpha: 0.35)),
            ),
            child: Icon(spec.icon, color: spec.color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(spec.label,
                    style: TextStyle(color: palette.muted, fontSize: 10)),
                const SizedBox(height: 2),
                Text(
                  spec.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: active ? palette.redHot : palette.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    spec.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: palette.muted, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonTile extends StatelessWidget {
  final _EmergencyPalette palette;
  final String initials;
  final String name;
  final String meta;
  final Color color;

  const _PersonTile({
    required this.palette,
    required this.initials,
    required this.name,
    required this.meta,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: color.withValues(alpha: 0.16),
            child: Text(
              initials,
              style: TextStyle(color: color, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        color: palette.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
                Text(meta,
                    style: TextStyle(color: palette.muted, fontSize: 10.5)),
              ],
            ),
          ),
          _SmallIconButton(palette: palette, icon: Icons.call_outlined),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final _EmergencyPalette palette;
  final IconData icon;
  final String title;
  final String subtitle;

  const _ContactTile({
    required this.palette,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: palette.red.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: palette.redHot, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: palette.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
                Text(subtitle,
                    style: TextStyle(color: palette.muted, fontSize: 10.5)),
              ],
            ),
          ),
          _SmallIconButton(palette: palette, icon: Icons.call_outlined),
        ],
      ),
    );
  }
}

class _IncidentProgress extends StatelessWidget {
  final _EmergencyPalette palette;
  final List<IncidentStep> steps;

  const _IncidentProgress({
    required this.palette,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final displaySteps = steps.isEmpty
        ? [
            ('Reported', '08:42 AM', true),
            ('Dispatched', '08:43 AM', true),
            ('En Route', '', false),
            ('On Scene', '', false),
          ]
        : steps.map((s) => (s.name, s.time, s.completed)).toList();

    return SizedBox(
      height: 62,
      child: Row(
        children: [
          for (var i = 0; i < displaySteps.length; i++) ...[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: displaySteps[i].$3 ? palette.red : palette.line,
                    child: Icon(
                      displaySteps[i].$3 ? Icons.check_rounded : Icons.circle,
                      color: Colors.white,
                      size: displaySteps[i].$3 ? 13 : 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displaySteps[i].$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: palette.muted, fontSize: 9),
                  ),
                  Text(
                    displaySteps[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: palette.text, fontSize: 8),
                  ),
                ],
              ),
            ),
            if (i != displaySteps.length - 1)
              Expanded(
                child: Divider(
                  color: displaySteps[i].$3 ? palette.red : palette.line,
                  thickness: 1.5,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _BannerAction extends StatelessWidget {
  final _EmergencyPalette palette;
  final IconData icon;
  final String label;

  const _BannerAction({
    required this.palette,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: palette.red.withValues(alpha: 0.24)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: palette.redHot, size: 14),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: palette.redHot,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapLegendDot extends StatelessWidget {
  final String label;
  final Color color;

  const _MapLegendDot(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9DB2D8),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MiniButton extends StatelessWidget {
  final _EmergencyPalette palette;
  final String label;

  const _MiniButton({required this.palette, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: palette.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: palette.blue.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: palette.blue,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PriorityPill extends StatelessWidget {
  final _EmergencyPalette palette;

  const _PriorityPill({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: palette.red.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: palette.red.withValues(alpha: 0.45)),
      ),
      child: Text(
        'High Priority',
        style: TextStyle(
          color: palette.redHot,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final _EmergencyPalette palette;
  final IconData icon;

  const _SmallIconButton({required this.palette, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: palette.control,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: palette.border),
      ),
      child: Icon(icon, color: palette.muted, size: 15),
    );
  }
}

class _SituationMapPainter extends CustomPainter {
  final _EmergencyPalette palette;

  const _SituationMapPainter({required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    final incident = Offset(size.width * 0.57, size.height * 0.54);
    for (var i = 4; i >= 1; i--) {
      canvas.drawCircle(
        incident,
        i * 18,
        Paint()
          ..color = palette.red.withValues(alpha: 0.045)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        incident,
        i * 18,
        Paint()
          ..color = palette.red.withValues(alpha: 0.16)
          ..style = PaintingStyle.stroke,
      );
    }
    _drawNode(canvas, size, incident, palette.red, Icons.warning_rounded);
    _drawNode(canvas, size, Offset(size.width * 0.22, size.height * 0.58),
        palette.green, Icons.directions_bus_rounded);
    _drawNode(canvas, size, Offset(size.width * 0.74, size.height * 0.42),
        palette.green, Icons.directions_bus_rounded);
    _drawNode(canvas, size, Offset(size.width * 0.38, size.height * 0.24),
        palette.blue, Icons.security_rounded);
    _drawNode(canvas, size, Offset(size.width * 0.79, size.height * 0.72),
        palette.gold, Icons.videocam_rounded);
    _drawPath(
        canvas,
        size,
        [
          Offset(size.width * 0.12, size.height * 0.37),
          Offset(size.width * 0.25, size.height * 0.28),
          Offset(size.width * 0.31, size.height * 0.33),
        ],
        palette.redHot);
    _drawPath(
        canvas,
        size,
        [
          Offset(size.width * 0.68, size.height * 0.33),
          Offset(size.width * 0.82, size.height * 0.47),
          Offset(size.width * 0.91, size.height * 0.40),
        ],
        palette.blue);
  }

  void _drawPath(Canvas canvas, Size size, List<Offset> points, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawNode(
    Canvas canvas,
    Size size,
    Offset center,
    Color color,
    IconData icon,
  ) {
    canvas.drawCircle(
      center,
      16,
      Paint()..color = color.withValues(alpha: 0.16),
    );
    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = palette.card
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
          fontSize: 15,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _SituationMapPainter oldDelegate) =>
      oldDelegate.palette != palette;
}

class _HeartbeatPainter extends CustomPainter {
  final Color color;

  const _HeartbeatPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(0, size.height * 0.55);
    for (var i = 1; i < 12; i++) {
      final x = size.width * i / 11;
      final spike = i == 4 || i == 8;
      final y = spike
          ? size.height * 0.14
          : size.height * (0.52 + math.sin(i) * 0.10);
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartbeatPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _StatSpec {
  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color color;

  const _StatSpec(
    this.label,
    this.value,
    this.caption,
    this.icon,
    this.color,
  );
}

class _EmergencyPalette {
  final bool isDark;

  const _EmergencyPalette(this.isDark);

  Color get page => isDark ? const Color(0xFF020914) : AppTheme.lightBackground;
  Color get pageAlt =>
      isDark ? const Color(0xFF03182C) : const Color(0xFFEAF4FF);
  Color get card => isDark ? const Color(0xFF061A2F) : Colors.white;
  Color get control =>
      isDark ? const Color(0xFF071F3B) : const Color(0xFFF3F8FF);
  Color get border =>
      isDark ? const Color(0xFF0D4A79) : const Color(0xFFC8DFFF);
  Color get line => isDark ? const Color(0xFF123554) : const Color(0xFFD9E7FA);
  Color get text => isDark ? Colors.white : const Color(0xFF061B44);
  Color get muted => isDark ? const Color(0xFF9DB2D8) : const Color(0xFF577099);
  Color get shadow => isDark
      ? Colors.black.withValues(alpha: 0.22)
      : const Color(0xFF9CC9FF).withValues(alpha: 0.18);
  Color get blue => const Color(0xFF0EA5FF);
  Color get green => const Color(0xFF18D47B);
  Color get gold => const Color(0xFFFFB020);
  Color get red => const Color(0xFFE53935);
  Color get redHot => const Color(0xFFFF4040);
  Color get redDark => const Color(0xFF4D0B14);
}

class IncidentStep {
  final String name;
  final String time;
  final bool completed;

  const IncidentStep({
    required this.name,
    required this.time,
    required this.completed,
  });
}
