import 'package:flutter/material.dart';
import 'package:smart_road_app/core/theme/app_theme.dart';
import 'package:smart_road_app/core/animations/app_animations.dart';

/// Enhanced Gradient Button
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool fullWidth;
  
  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    Gradient? gradient,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
    this.fullWidth = false,
  }) : gradient = gradient ?? AppTheme.primaryGradient;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : width,
      height: height ?? 56,
      decoration: BoxDecoration(
        gradient: onPressed != null && !isLoading ? gradient : null,
        color: onPressed == null || isLoading 
            ? Colors.grey.withValues(alpha: 0.3)
            : null,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        boxShadow: onPressed != null && !isLoading
            ? [
                BoxShadow(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        text,
                        style: textStyle ??
                            TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Modern Elevated Button with Animation
class ModernElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;
  final double? borderRadius;
  final bool isLoading;
  final bool fullWidth;
  
  const ModernElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
    this.fullWidth = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AppAnimations.scaleIn(
      child: Container(
        width: fullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: backgroundColor ?? 
              (isDark ? AppTheme.primaryPurple : AppTheme.primaryPurple),
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? AppTheme.primaryPurple).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.center,
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          foregroundColor ?? Colors.white,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: foregroundColor ?? Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: TextStyle(
                            color: foregroundColor ?? Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Status Tag with Modern Design
class StatusTag extends StatelessWidget {
  final String status;
  final Color? color;
  
  const StatusTag({
    super.key,
    required this.status,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    final statusColor = color ?? AppTheme.getStatusColor(status);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: isDark ? 0.2 : 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
