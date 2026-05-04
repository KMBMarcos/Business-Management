import { FastifyInstance } from 'fastify';

export default async function activityRoutes(fastify: FastifyInstance) {
  fastify.get('/', { preHandler: [fastify.authenticate] }, async () => {
    return fastify.prisma.activityLog.findMany({
      include: { user: { select: { id: true, name: true, email: true, role: { select: { name: true } } } } },
      orderBy: { createdAt: 'desc' },
      take: 100
    });
  });

  fastify.get('/latest', { preHandler: [fastify.authenticate] }, async () => {
    return fastify.prisma.activityLog.findMany({
      include: { user: { select: { id: true, name: true } } },
      orderBy: { createdAt: 'desc' },
      take: 10
    });
  });
}
