import { PrismaClient } from '@prisma/client';

export async function logActivity(
  prisma: PrismaClient,
  input: {
    userId?: number | null;
    action: string;
    entityType?: string;
    entityId?: number;
    message: string;
    metadata?: unknown;
  }
) {
  return prisma.activityLog.create({
    data: {
      userId: input.userId || null,
      action: input.action,
      entityType: input.entityType,
      entityId: input.entityId,
      message: input.message,
      metadata: input.metadata ? JSON.stringify(input.metadata) : null
    }
  });
}
