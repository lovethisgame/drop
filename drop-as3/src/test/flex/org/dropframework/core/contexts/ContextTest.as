/*
 * Copyright 2013 Drop Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.dropframework.core.contexts
{

    import org.dropframework.mvc.controller.Controller;
    import org.flexunit.asserts.*;

    import sandboxes.tiny.controller.SomeController;
    import sandboxes.tiny.actors.singletones.ISomeController;


    public class ContextTest
    {
        private var context : IContext;


        [Before]
        public function beforeTest() : void
        {
            context = new Context();
            SomeController.resetInstances();
        }

        [After]
        public function afterTest() : void
        {
            context = null;
        }


        [Test]
        public function testEmptyOnStart() : void
        {
            assertNull(context.instanceOf(ISomeController));
        }


        [Test]
        public function testRegistersOnce() : void
        {
            var controller : Controller = new SomeController(context);
            assertNotNull(context.instanceOf(ISomeController));

            context.register(controller);
            context.register(controller);
            context.register(controller);

            assertNotNull(context.instanceOf(ISomeController));
            assertEquals(1, SomeController.instances);
        }


        [Test]
        public function testRegister() : void
        {
            new SomeController(context);
            assertNotNull(context.instanceOf(ISomeController));
        }


        [Test]
        public function testRemove() : void
        {
            // todo: add tests
        }


        [Test]
        public function testRemoveAll() : void
        {
            // todo: add tests
        }


        [Test(expects="org.dropframework.core.commons.DropFrameworkError")]
        public function testInstanceOfMultipleReturn() : void
        {
            new SomeController(context);
            new SomeController(context);
            assertEquals(2, SomeController.instances);
            context.instanceOf(ISomeController);
        }


        [Test]
        public function testInstanceOf() : void
        {
            new SomeController(context);
            assertNotNull(context.instanceOf(ISomeController));
            assertEquals("Hello Drop!", ISomeController(context.instanceOf(ISomeController)).doSomething("Drop"))
        }


        [Test]
        public function testArrayOf() : void
        {
            assertEquals(context.arrayOf(ISomeController).length, 0);
            for (var i : int = 0; i < 3; i++)
            {
                new SomeController(context);
                assertEquals(SomeController.instances, context.arrayOf(ISomeController).length);
            }
        }


        [Test]
        public function testCall() : void
        {
            // todo: add tests
        }
    }
}
