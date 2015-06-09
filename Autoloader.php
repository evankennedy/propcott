<?php
class Autoloader extends \Worker {

    public function __construct($loader) {
        $this->loader = $loader;
    }
    
    /* include autoloader for Tasks */
    public function run()   { require_once($this->loader); }
    
    /* override default inheritance behaviour for the new threaded context */
    public function start() { return parent::start(PTHREADS_INHERIT_NONE); }
    
    protected $loader;
}