import { createClient } from '@supabase/supabase-js';
import { Platform } from 'react-native';

const supabaseUrl = 'https://wrrgshlogiokeygsnqhf.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndycmdzaGxvZ2lva2V5Z3NucWhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc1NjE4OTYsImV4cCI6MjA4MzEzNzg5Nn0.7Xl5XPQGvbF_hiCP4YhKCpVydAC-CQiCkc9hqPPPU3o';

// Storage adapter for web and native
const storage = Platform.OS === 'web'
  ? {
      getItem: (key: string) => {
        if (typeof window !== 'undefined') {
          return Promise.resolve(localStorage.getItem(key));
        }
        return Promise.resolve(null);
      },
      setItem: (key: string, value: string) => {
        if (typeof window !== 'undefined') {
          localStorage.setItem(key, value);
        }
        return Promise.resolve();
      },
      removeItem: (key: string) => {
        if (typeof window !== 'undefined') {
          localStorage.removeItem(key);
        }
        return Promise.resolve();
      },
    }
  : undefined;

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: storage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
});

// Auth helpers
export const signUp = async (email: string, password: string) => {
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
  });
  return { data, error };
};

export const signIn = async (email: string, password: string) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });
  return { data, error };
};

export const signOut = async () => {
  const { error } = await supabase.auth.signOut();
  return { error };
};

export const getCurrentUser = async () => {
  const { data: { user } } = await supabase.auth.getUser();
  return user;
};

export const getSession = async () => {
  const { data: { session } } = await supabase.auth.getSession();
  return session;
};

// OAuth Social Login helpers
type OAuthProvider = 'google' | 'kakao' | 'naver';

export const signInWithOAuth = async (provider: OAuthProvider) => {
  const redirectUrl = Platform.OS === 'web'
    ? window.location.origin
    : 'mydeepedive://auth/callback';

  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: provider === 'naver' ? 'kakao' : provider, // Naver uses custom OIDC, fallback for now
    options: {
      redirectTo: redirectUrl,
      skipBrowserRedirect: Platform.OS !== 'web',
    },
  });
  return { data, error };
};

export const signInWithGoogle = async () => {
  return signInWithOAuth('google');
};

export const signInWithKakao = async () => {
  return signInWithOAuth('kakao');
};

// Note: Naver requires custom OIDC setup in Supabase
export const signInWithNaver = async () => {
  // Naver OAuth is handled through custom OIDC provider
  const redirectUrl = Platform.OS === 'web'
    ? window.location.origin
    : 'mydeepedive://auth/callback';

  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: 'kakao', // Placeholder - will need custom OIDC setup for Naver
    options: {
      redirectTo: redirectUrl,
    },
  });
  return { data, error };
};
