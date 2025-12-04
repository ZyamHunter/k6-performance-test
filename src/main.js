import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// Métricas customizadas
export let errorRate = new Rate('errors');
export let purchaseSuccessRate = new Rate('purchase_success');

export const options = {
  // As opções serão carregadas dos arquivos de configuração JSON
  thresholds: {
    http_req_duration: ['p(90)<2000'], // 90th percentil deve ser menor que 2 segundos
    http_req_failed: ['rate<0.05'], // Taxa de erro menor que 5%
    purchase_success: ['rate>0.95'], // Taxa de sucesso na compra maior que 95%
    errors: ['rate<0.05']
  },
  ext: {
    loadimpact: {
      name: "BlazDemo Performance Test - Optimized"
    }
  }
};

// Configuração de think time otimizada
const THINK_TIME = {
  load: parseFloat(__ENV.THINK_TIME_LOAD) || 0.2,    // 200ms para load test
  spike: parseFloat(__ENV.THINK_TIME_SPIKE) || 0.5,   // 500ms para spike test
  default: parseFloat(__ENV.THINK_TIME) || 0.3        // 300ms padrão
};

// Detectar tipo de teste atual
const currentTestType = __ENV.TEST_TYPE || 'default';
const thinkTime = THINK_TIME[currentTestType] || THINK_TIME.default;

export function setup() {
  console.log('🚀 Iniciando teste de performance BlazDemo - VERSÃO OTIMIZADA');
  console.log('📋 Objetivo: Simular compra de passagem aérea');
  console.log('🎯 Meta: 250 RPS com p90 < 2s');
  console.log(`⏱️  Think Time configurado: ${thinkTime}s (Tipo: ${currentTestType})`);
}

export default function () {
  // Grupo: Acessar página inicial
  let response = http.get('https://www.blazedemo.com/', {
    tags: { step: 'homepage' }
  });
  
  check(response, {
    'Homepage loaded successfully': (r) => r.status === 200,
    'Homepage contains title': (r) => r.body.includes('Welcome to the Simple Travel Agency!')
  }) || errorRate.add(1);

  // Think time otimizado - usuário lendo a página
  sleep(thinkTime);

  // Grupo: Selecionar origem e destino
  response = http.get('https://www.blazedemo.com/', {
    tags: { step: 'select_destination' }
  });

  // Extrair dados do formulário
  let formData = {
    fromPort: 'Boston',
    toPort: 'London'
  };

  // Grupo: Buscar voos
  response = http.post('https://www.blazedemo.com/reserve.php', formData, {
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    tags: { step: 'search_flights' }
  });

  let flightSearchSuccess = check(response, {
    'Flight search successful': (r) => r.status === 200,
    'Flights list displayed': (r) => r.body.includes('Flights from Boston to London')
  });

  if (!flightSearchSuccess) {
    errorRate.add(1);
    return; // Para o teste se não conseguir buscar voos
  }

  // Think time otimizado - usuário analisando opções de voos
  sleep(thinkTime);

  // Grupo: Selecionar voo e prosseguir para compra
  // Simular clique no primeiro voo disponível
  response = http.post('https://www.blazedemo.com/purchase.php', {
    flight: '43',
    price: '472.56',
    airline: 'United Airlines',
    fromPort: 'Boston',
    toPort: 'London'
  }, {
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    tags: { step: 'select_flight' }
  });

  check(response, {
    'Purchase page loaded': (r) => r.status === 200,
    'Purchase form displayed': (r) => r.body.includes('Your flight from TLV to SFO has been reserved')
  }) || errorRate.add(1);

  // Think time otimizado - usuário preenchendo formulário
  sleep(thinkTime);

  // Grupo: Preencher dados de compra e finalizar
  const purchaseData = {
    inputName: 'João Silva',
    address: 'Rua das Flores, 123',
    city: 'São Paulo',
    state: 'SP',
    zipCode: '01234-567',
    cardType: 'visa',
    creditCardNumber: '4111111111111111',
    creditCardMonth: '12',
    creditCardYear: '2027',
    nameOnCard: 'João Silva'
  };

  response = http.post('https://www.blazedemo.com/confirmation.php', purchaseData, {
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    tags: { step: 'complete_purchase' }
  });

  let purchaseSuccess = check(response, {
    'Purchase completed successfully': (r) => r.status === 200,
    'Confirmation page displayed': (r) => r.body.includes('Thank you for your purchase today!'),
    'Confirmation ID present': (r) => r.body.includes('Id:')
  });

  // Registrar métricas de sucesso da compra
  purchaseSuccessRate.add(purchaseSuccess ? 1 : 0);
  
  if (!purchaseSuccess) {
    errorRate.add(1);
    console.error('❌ Falha na compra da passagem');
  } else {
    console.log('✅ Compra realizada com sucesso');
  }

  // Think time otimizado - usuário visualizando confirmação
  sleep(thinkTime * 0.5); // Menor tempo na confirmação
}

export function teardown() {
  console.log('📊 Teste finalizado - Verificar relatórios para análise detalhada');
}