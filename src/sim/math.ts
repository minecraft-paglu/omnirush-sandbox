export type Vec2 = { x: number; y: number };
export type Vec3 = { x: number; y: number; z: number };

export const vec3 = (x = 0, y = 0, z = 0): Vec3 => ({ x, y, z });
export const add = (a: Vec3, b: Vec3): Vec3 => vec3(a.x + b.x, a.y + b.y, a.z + b.z);
export const scale = (a: Vec3, value: number): Vec3 => vec3(a.x * value, a.y * value, a.z * value);
export const lengthXZ = (a: Vec3): number => Math.hypot(a.x, a.z);
export const distanceXZ = (a: Vec3, b: Vec3): number => Math.hypot(a.x - b.x, a.z - b.z);
export const clamp = (value: number, min: number, max: number): number => Math.max(min, Math.min(max, value));
export const moveToward = (current: number, target: number, maxDelta: number): number => {
  if (Math.abs(target - current) <= maxDelta) return target;
  return current + Math.sign(target - current) * maxDelta;
};
export const normalizeXZ = (a: Vec3): Vec3 => {
  const length = lengthXZ(a);
  return length > 0.0001 ? vec3(a.x / length, 0, a.z / length) : vec3();
};
export const rotateY = (a: Vec3, angle: number): Vec3 => {
  const c = Math.cos(angle);
  const s = Math.sin(angle);
  return vec3(a.x * c - a.z * s, a.y, a.x * s + a.z * c);
};
export const forwardFromYaw = (yaw: number): Vec3 => vec3(Math.sin(yaw), 0, Math.cos(yaw));
export const yawFor = (direction: Vec3): number => Math.atan2(direction.x, direction.z);
export const approachAngle = (current: number, target: number, maxDelta: number): number => {
  let delta = ((target - current + Math.PI) % (Math.PI * 2)) - Math.PI;
  if (delta < -Math.PI) delta += Math.PI * 2;
  return current + clamp(delta, -maxDelta, maxDelta);
};
