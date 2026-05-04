export const USER_COLORS = ['#7C9CBF', '#8BAE92', '#B89B7A', '#9B8BC2', '#C27F8E', '#7FB8B4', '#A7A37A', '#8FA1C7', '#B184A7', '#86A873'];

export function getUserColor(user: any) {
  return user?.color || USER_COLORS[Math.abs(Number(user?.id || 0)) % USER_COLORS.length];
}

export function initials(name?: string) {
  return (name || 'U').split(' ').filter(Boolean).slice(0, 2).map((part) => part[0]?.toUpperCase()).join('') || 'U';
}

export function Avatar({ user, size = 40 }: { user: any; size?: number }) {
  const style = { width: size, height: size, backgroundColor: getUserColor(user) };
  if (user?.avatar) {
    return <img src={user.avatar} alt={user.name} className="rounded-full object-cover shrink-0" style={style} />;
  }

  return (
    <div className="rounded-full flex items-center justify-center text-white font-bold shrink-0" style={style}>
      <span style={{ fontSize: Math.max(12, Math.floor(size / 2.5)) }}>{initials(user?.name)}</span>
    </div>
  );
}
