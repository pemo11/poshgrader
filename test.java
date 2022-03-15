class Test {
    
    boolean testeSchaltjahr(int jahr) {
	return jahr % 4 == 0 && jahr % 400 != 0;
    }
}