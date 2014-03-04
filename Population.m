
#import "Population.h"

@implementation Population
- (id) init
{
    if ([super init])
    {
        inds = [[NSMutableArray alloc] init];
        [inds autorelease];
        for (int i = 0; i < 50; ++i)
        {
            Individual *newInd = [[Individual alloc] init];
            [newInd autorelease];
            [inds addObject:newInd];
        }
    }
    return self;
}
- (void) printPopulation
{
    for (int i = 0; i < 50; ++i)
    {
        Individual *ind = [inds objectAtIndex:i];
        [ind printIndividual];
    }
}
- (void) calcPopFitness
{
    for (int i = 0; i < 50; ++i)
    {
        [[inds objectAtIndex:i] calcFitness];
    }
}
- (void) mutation
{
    for (int i = 0; i < 50; ++i)
    {
        [[inds objectAtIndex:i] mutation];
    }
}
/* 昇順にソート */
- (void) sort
{
    [inds sortUsingSelector:@selector(compare:)];
}
- (void) insert: (int) index : (Individual*) ind
{
    [inds replaceObjectAtIndex:index withObject:ind];
}
- (void) printMaxIndividual
{
    int max = 0;
    int index = 0;
    for (int i = 0; i < 50; ++i)
    {
        Individual *ind = [inds objectAtIndex:i];
        if (ind.fitness > max)
        {
            max = ind.fitness;
            index = i;
        }
    }
    [[inds objectAtIndex:index] printIndividual];
}
- (void) crossover:(int)index
{
    Individual *parent1 = [self selectOffspring];
    Individual *parent2 = [self selectOffspring];
    Individual *child1 = [parent1 deepCopy];
    Individual *child2 = [parent2 deepCopy];
    int sep1 = rand()%17 + 1;
    int sep2 = rand()%17 + 1;
    if (sep1 > sep2)
    {
        int tmp = sep1;
        sep1 = sep2;
        sep2 = tmp;
    }
    else if (sep1 == sep2)
    {
        sep2++;
    }
    for (int i = sep1; i < sep2; ++i)
    {
        int tmp = child1 -> array[i];
        child1 -> array[i] = child2 -> array[i];
        child2 -> array[i] = tmp;
    }
    [child1 mutation];
    [child2 mutation];
    [child1 calcFitness];
    [child2 calcFitness];
    if (child1.fitness > child2.fitness)
    {
        [self insert:index:child1];
    }
    else
    {
        [self insert:index:child2];
    }
}
- (void) applyCrossover
{
    for (int i = 0; i < 25; i++)
    {
        [self crossover:i];
    }
}
- (Individual*) selectOffspring
{
    int fitSum = 0;
    for (int i = 0; i < 50; ++i)
    {
        Individual *ind = [inds objectAtIndex:i];
        fitSum += ind.fitness;
    }
    double random = randDouble(1.0);
    double checkPoint = fitSum * random;
    fitSum = 0;
    for (int i = 0; i < 50; ++i)
    {
        Individual *ind = [inds objectAtIndex:i];
        fitSum += ind.fitness;
        if (fitSum > checkPoint)
        {
            return ind;
        }
    }
    return NULL;
}
@end