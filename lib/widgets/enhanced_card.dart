import 'package:flutter/material.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';

/// Enhanced Card Widget with Modern Design
class EnhancedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final BoxShadow? shadow;
  final bool showBorder;
  final Color? borderColor;
  
  const EnhancedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.elevation = 2,
    this.onTap,
    this.borderRadius,
    this.shadow,
    this.showBorder = false,
    this.borderColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? 
            (isDark ? AppTheme.darkCardBackground : AppTheme.cardBackground),
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: showBorder
            ? Border.all(
                color: borderColor ?? 
                    (isDark ? AppTheme.borderDark : AppTheme.borderLight),
                width: 1.5,
              )
            : null,
        boxShadow: shadow != null
            ? [shadow!]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: elevation! * 4,
                  offset: Offset(0, elevation! * 2),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Gradient Card Widget
class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  
  const GradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.margin,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return EnhancedCard(
      gradient: gradient,
      onTap: onTap,
      padding: padding,
      margin: margin,
      elevation: 4,
      child: child,
    );
  }
}

/// Service Type Card with Color Coding
class ServiceTypeCard extends StatelessWidget {
  final String serviceType;
  final Widget child;
  final VoidCallback? onTap;
  
  const ServiceTypeCard({
    super.key,
    required this.serviceType,
    required this.child,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getServiceTypeColor(serviceType);
    
    return EnhancedCard(
      onTap: onTap,
      showBorder: true,
      borderColor: color.withValues(alpha: 0.3),
      backgroundColor: color.withValues(alpha: 0.05),
      child: child,
    );
  }
}
