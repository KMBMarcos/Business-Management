import { useQuery } from '@tanstack/react-query';
import { companyApi } from '../api/client';

export function useCompany() {
  const { data } = useQuery({ queryKey: ['company-settings'], queryFn: companyApi.get });

  return {
    companyName: data?.companyName || 'DevFast',
    companyObjective: data?.companyObjective || 'Manager open-source para operar proyectos, infraestructura, finanzas y equipo.',
    companyLogoUrl: data?.companyLogoUrl || '',
  };
}
