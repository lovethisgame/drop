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
package org.dropframework.core.actors
{

    import org.dropframework.core.commons.DropFrameworkError;
    import org.dropframework.core.contexts.IContext;


    /**
     * Simple implementation of the IActor interface which requires the context to be supplied as a constructor
     * argument, thus providing context related capabilities within the controller.
     *
     * Designed for extension by subclasses. Extended by MVC's classes: Model, Mediator and Controller.
     *
     * @author jdanilov
     * */
    public class ContextAwareActor
        implements IActor, IContext
    {
        private var _context : IContext;


        /** Actor's context. Non null. */
        protected function get context () : IContext
        {
            return _context;
        }



        /**
         * Creates new ContextAwareActor for a given context. Automatically registers itself in the context.
         *
         * @param context - context to be used by the controller.
         * @param autoregister - if true, actor will be automatically registered in the context.
         * */
        public function ContextAwareActor (context : IContext, autoregister : Boolean = true)
        {
            if (context == null)
                throw new DropFrameworkError("ContextAwareActor requires non null instance of IContext");
            this._context = context;
            if (autoregister)
                context.register(this);
        }


        public function register (actor : IActor) : void
        {
            _context.register(actor);
        }


        public function remove (actor : IActor) : void
        {
            _context.remove(actor);
        }


        public function removeAll () : void
        {
            _context.removeAll();
        }


        public function instanceOf (type : Class) : IActor
        {
            return _context.instanceOf(type);
        }


        public function arrayOf (type : Class) : Array
        {
            return _context.arrayOf(type);
        }


        public function call (targetType : Class, callbackOrArgs : Object = null) : void
        {
            return _context.call(targetType, callbackOrArgs);
        }
    }
}