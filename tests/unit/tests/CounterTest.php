<?php

require __DIR__ . '/../../../nano-app/Counter.php';

class CounterTest extends PHPUnit_Framework_TestCase {

    /**
     * @var Counter
     */
    protected $counter;

    public function setUp()
    {
        $this->counter = new Counter(new PDO('sqlite::memory:'));
    }

    /**
     * @test
     */
    public function increaseCount()
    {
        $counterBefore = $this->counter->getCurrentCounter();
        $this->counter->increaseCounter();
        $counterAfter = $this->counter->getCurrentCounter();
        $this->assertGreaterThan($counterBefore, $counterAfter);
    }

    /**
     * @test
     */
    public function counterDoesNotChangeIfNotIncreased() {
        $this->counter->increaseCounter();
        $counterFirst = $this->counter->getCurrentCounter();
        $counterThen = $this->counter->getCurrentCounter();
        $this->assertEquals($counterFirst, $counterThen);

    }

    /**
     * @test
     */
    public function zeroAfterResetting() {
        $this->counter->increaseCounter();
        $counterFirst = $this->counter->getCurrentCounter();
        $this->assertGreaterThan(0, $counterFirst);
        $this->counter->reset();
        $counterThen = $this->counter->getCurrentCounter();
        $this->assertEquals(0, $counterThen);
    }

}