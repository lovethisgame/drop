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

    import org.dropframework.core.actors.IActor;
    import org.dropframework.mvc.controller.Controller;
    import org.flexunit.asserts.*;

    import sandboxes.tiny.actors.notifications.IOnExtendedEvent;
    import sandboxes.tiny.actors.notifications.IOnParameterizedEvent;

    import sandboxes.tiny.actors.notifications.IOnSimpleEvent;

    import sandboxes.tiny.controller.EventListener;

    import sandboxes.tiny.controller.EventListener;

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
            var c : IActor = new SomeController(context);
            assertEquals(1, SomeController.instances);
            assertNotNull(context.instanceOf(ISomeController));

            context.remove(c);
            assertEquals(1, SomeController.instances);
            assertNull(context.instanceOf(ISomeController));

            context.remove(c);
            new SomeController(context);
            new SomeController(context);
            context.remove(c);
            assertEquals(3, SomeController.instances);
            assertEquals(2, context.arrayOf(ISomeController).length);

            var d : IActor = new SomeController(context);
            context.register(c);
            assertEquals(4, SomeController.instances);
            assertEquals(4, context.arrayOf(ISomeController).length);

            context.remove(c);
            assertEquals(4, SomeController.instances);
            assertEquals(3, context.arrayOf(ISomeController).length);

            context.remove(d);
            assertEquals(4, SomeController.instances);
            assertEquals(2, context.arrayOf(ISomeController).length);
        }


        [Test]
        public function testRemoveAll() : void
        {
            var c : IActor = new SomeController(context);
            assertEquals(1, SomeController.instances);
            assertNotNull(context.instanceOf(ISomeController));

            context.removeAll();
            assertEquals(1, SomeController.instances);
            assertNull(context.instanceOf(ISomeController));

            new SomeController(context);
            new SomeController(context);
            context.register(c);
            assertEquals(3, SomeController.instances);
            assertEquals(3, context.arrayOf(ISomeController).length);

            context.removeAll();
            assertEquals(3, SomeController.instances);
            assertEquals(0, context.arrayOf(ISomeController).length);
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
            var a : EventListener = new EventListener(context);
            var b : EventListener = new EventListener(context);
            assertEquals(a.eventCount, 0);
            assertEquals(b.eventCount, 0);

            context.call(IOnSimpleEvent);
            assertEquals(a.eventCount, 1);
            assertEquals(b.eventCount, 1);

            context.call(IOnExtendedEvent);
            assertEquals(a.eventCount, 2);
            assertEquals(b.eventCount, 2);

            context.call(IOnParameterizedEvent, "value");
            assertEquals(a.eventCount, 4);
            assertEquals(b.eventCount, 4);

            context.call(IOnSimpleEvent,
                    function (a : IOnSimpleEvent) : void { a.onSimpleEvent(); });
            assertEquals(a.eventCount, 5);
            assertEquals(b.eventCount, 5);

            context.call(IOnExtendedEvent,
                    function (a : IOnExtendedEvent) : void { a.onSimpleEvent(); a.onExtendedEvent(); });
            assertEquals(a.eventCount, 7);
            assertEquals(b.eventCount, 7);

            context.call(IOnExtendedEvent,
                    function (a : IOnParameterizedEvent) : void { a.onParameterizedEvent1("value"); });
            assertEquals(a.eventCount, 8);
            assertEquals(b.eventCount, 8);

            context.call(IOnParameterizedEvent, ["value"]);
            assertEquals(a.eventCount, 10);
            assertEquals(b.eventCount, 10);

            context.remove(a);
            context.call(IOnSimpleEvent);
            assertEquals(a.eventCount, 10);
            assertEquals(b.eventCount, 11);

            context.remove(b);
            context.call(IOnSimpleEvent);
            assertEquals(a.eventCount, 10);
            assertEquals(b.eventCount, 11);

            context.register(a);
            context.call(IOnSimpleEvent);
            assertEquals(a.eventCount, 11);
            assertEquals(b.eventCount, 11);


        }
    }
}
