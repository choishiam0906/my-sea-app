import React, { forwardRef } from 'react';
import { View, TextInput, Text, TextInputProps } from 'react-native';

interface InputProps extends TextInputProps {
  label?: string;
  error?: string;
  hint?: string;
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
}

export const Input = forwardRef<TextInput, InputProps>(
  ({ label, error, hint, leftIcon, rightIcon, className = '', ...props }, ref) => {
    return (
      <View className="w-full">
        {label && (
          <Text className="text-text-main font-medium mb-2">{label}</Text>
        )}
        <View
          className={`flex-row items-center bg-surface rounded-2xl border-2 px-4 ${
            error ? 'border-red-400' : 'border-gray-200'
          } ${className}`}
        >
          {leftIcon && <View className="mr-3">{leftIcon}</View>}
          <TextInput
            ref={ref}
            className="flex-1 py-3 text-text-main text-base"
            placeholderTextColor="#78909C"
            {...props}
          />
          {rightIcon && <View className="ml-3">{rightIcon}</View>}
        </View>
        {error && (
          <Text className="text-red-500 text-sm mt-1">{error}</Text>
        )}
        {hint && !error && (
          <Text className="text-text-sub text-sm mt-1">{hint}</Text>
        )}
      </View>
    );
  }
);

Input.displayName = 'Input';
