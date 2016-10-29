class GradientDescent
{
  Network network;      //Réseau à entraîner
  
  ActivationFunction f;
  
  float[][] inputs;     //X : valeurs d'entrée pour chaque exemple
  float[][] outputs;    //Y : valeurs de sortie pour chaque exemple
  
  float[][][] weights;  //Valeur extraite du network : les poids de chaque neurone de chaque couche
  
  float[][][] sums;     //Somme de chaque neurone de chaque couche avant fonction d'activation
  float[][][] answers;  //Somme de chaque neurone de chaque couche après fonction d'activation
  
  
  GradientDescent(Network n, float[][] i, float[][] o){
    network = n;
    inputs = i;
    outputs = o;
    
    f = n.f;
    weights = n.getAllWeights();
  }
  
  
  void train(){
    
    float[][][] dJdW = costFunctionPrime(); 
    
    float scalar=1000;
    for(int layer=0; layer<network.layers.length; layer++){
      weights[layer] = mSub(weights[layer], mT(mProduct(dJdW[layer],scalar)) );
    }
    
    network.newWeights(weights);  //Intègre les nouveaux poids dans le réseau
    
  }
  
  
  float cost(){
    float J=0;
    for(int e=0; e<inputs.length; e++){
      J += network.cost(inputs[e],outputs[e]);
    }
    return 0.5*J;
  }
  
  float[][][] costFunctionPrime(){
    
    processExamples();  //New sums and answers
    
    int nLayer = network.layers.length;
    
    float[][][] delta = new float[nLayer][][];
    float[][][] dJdW = new float[nLayer][][];
    
    //Last layer dJdW :
    nLayer -= 1;
    //delta[n] = mProduct( (mInv(mSub(outputs,getAnswersFromLayer(n)))), sigmoidPrime(getSumsFromLayer(n)) );
    //dJdW[n] = mDot( mT(getAnswersFromLayer(n-1)), delta[n]);    
    
    delta[nLayer] = mProduct( (mInv(mSub(outputs,answers[nLayer+1]))), f.prime(sums[nLayer]) );
    dJdW[nLayer] = mDot( mT(answers[nLayer]), delta[nLayer]); 
    
    for(int layer = nLayer-1; layer>=0; layer--){
      //delta[layer] = mProduct( mDot(delta[layer+1], (weights[layer+1])), sigmoidPrime(getSumsFromLayer(layer)));
      //dJdW[layer]  = mDot(mT(getAnswersFromLayer(layer-1)), delta[layer]);
      
      delta[layer] = mProduct( mDot(delta[layer+1], (weights[layer+1])), f.prime(sums[layer]));
      dJdW[layer]  = mDot(mT(answers[layer]), delta[layer]);
    }
    
    return dJdW;
  }
  
    
  void processExamples(){  //Récupère sums et answers du réseau pour chaque exemple
     
    //sums = new float[inputs.length][][];
    //answers = new float[inputs.length][][];

    sums = new float[network.layers.length][inputs.length][];
    answers = new float[network.layers.length+1][inputs.length][];
    
    answers[0] = inputs;
    
    for(int e=0; e<inputs.length; e++){  //Pour chaque exemple    
      network.forward(inputs[e]);
      
      for(int layer=0; layer<network.layers.length; layer++){  //Pour chaque couche
        sums[layer][e] = network.getSumsFromLayer(layer);
        answers[layer+1][e] = network.getAnswersFromLayer(layer);
      }
       
      //sums[e] = network.getAllSums();
      //answers[e] = network.getAllAnswers();
    }
    
  }
  
  /*
  float[][] getSumsFromLayer(int layer){  //TODO : à revoir (pas très optimisé)
    float[][] s = new float[answers.length][]; 
    for(int e=0; e<answers.length; e++) s[e] = sums[e][layer];
    return s;  
  }
  
  float[][] getAnswersFromLayer(int layer){  //TODO : à revoir (pas très optimisé)
    if(layer == -1) return inputs; //inputs
    
    float[][] ans = new float[answers.length][]; 
    for(int e=0; e<answers.length; e++) ans[e] = answers[e][layer];
    return ans;  
  }*/

}


class GeneticAlgorithm
{
  int population;       //Nombre de réseaux dans la population
  Network[] networks;   //Liste de réseaux

  float[][] inputs;     //X : valeurs d'entrée pour chaque exemple
  float[][] outputs;    //Y : valeurs de sortie pour chaque exemple
  
  
  GeneticAlgorithm(Network network, int n, float[][] i, float[][] o){
    networks = new Network[n];
    
    population = n;
    
    for(int j=0;j<n;j++) networks[j] = network.copyParameters();
    
    //for(int j=0;j<n;j++) showArray(networks[j].getAllWeights()[0]);
    
    inputs = i;
    outputs = o;
  }
  
  
  void train(){

    float[] costs = costs();

    float[] fitness = fitness(costs);
    
    float[] pool = probability(fitness);
    
    //printArray(pool);
    
    networks = selection(networks,pool,networks.length/2);  //Récupère la moitié des réseaux 
 
    int n = networks.length;
    for(int network=n; network<population; network++){  //Remplie la liste de réseaux avec de nouveaux réseaux à partir de ceux qui ont survécu
      networks = (Network[]) append(networks, crossover(networks[int(random(n))],networks[int(random(n))]));
    }

  }
  
  
  float[] costs(){
    float[] result = new float[networks.length];
    for(int network=0; network<networks.length; network++){
      result[network] = cost(networks[network]);
    }
    return result;
  }
  
  float cost(Network n){
    float J=0;
    for(int e=0; e<inputs.length; e++){
      J += n.cost(inputs[e],outputs[e]);
    }
    return 0.5*J;
  }
  
  
  float[] fitness(float[] x){
    float[] result = new float[x.length];
    for(int network=0; network<x.length; network++){
      result[network] = -x[network]/1000; 
    }
    return result;
  }
  
  float[] probability(float[] x){  //Crée le tableau de probabilité
    float sumSoftmax = sumSoftmax(x); 
    for(int i=0; i<x.length; i++) x[i] = exp(x[i])/sumSoftmax;
    return x;
  }
  
  float sumSoftmax(float[] x){ 
    float s=0;
    for(int i=0;i<x.length;i++) s+=exp(x[i]);
    return s;  
  }
  
  
  Network[] selection(Network[] networks, float[] x, int nElement){  //Récupère nElement d'un tableau de réseau en fonction des probabilités x

    Network[] result = new Network[nElement]; 
    
    float random=1;
    
    for(int i=0;i<nElement;i++){
      float r = random(random);
      float s = 0; int n=-1;
      do{
        n++;
        s += x[n];
      }while(s<r && n<x.length-1);
      
      if(n == x.length-1) println("error : cannot find network with probabilities",n);

      result[i] = networks[n];
      
      random -= x[n];
      x[n] = 0;
    }
    
    return result;
  }
  
  Network crossover(Network a, Network b){  //Mélange deux réseaux pour en créer un nouveau
    
    Network n = a.copyParameters();  //Créer un nouveau réseau avec les paramètres d'un parent
    
    float[][][] Wa = a.getAllWeights();  //Récupère les poids de chaque parent
    float[][][] Wb = b.getAllWeights();
    
    float[][][] Wn = copyArray(Wa);  //Initialise la tableau des poids de l'enfant aux mêmes dimensions que les parents 
    
    for(int i=0; i<Wa.length; i++){
      for(int j=0; j<Wa[i].length; j++){
        for(int k=0; k<Wa[i][j].length; k++){  //TODO : mutation
          if(random(100)<50) Wn[i][j][k] = Wa[i][j][k];
           else Wn[i][j][k] = Wb[i][j][k];
        }
      }  
    }
    
    n.newWeights(Wn);
    
    return n;
  }
  
  float[][][] copyArray(float[][][] x){  //Permet de créer un tableau en 3 dimensions de mêmes tailles qu'un autre tableau
    float[][][] result = new float[x.length][][];
    for(int i=0; i<x.length; i++){
      result[i] = new float[x[i].length][];
      for(int j=0; j<x[i].length; j++){
        result[i][j] = new float[x[i][j].length];
      }  
    }
    return result; 
  }
  
  
  
  Network bestNetwork(){  //Récupère le réseau dont le cost est le plus faible
    float[] costs = costs();
    int bestNetwork=0;
    for(int n=0;n<costs.length;n++){
      if(costs[n]<costs[bestNetwork]) bestNetwork = n;
    }
    println(bestNetwork,costs[bestNetwork]);
    return networks[bestNetwork];
  }
  
}