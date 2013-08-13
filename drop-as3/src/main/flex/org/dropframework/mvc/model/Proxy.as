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
package org.dropframework.mvc.model
{

    import org.dropframework.core.actors.ContextAwareActor;
    import org.dropframework.core.contexts.IContext;


    /**
     * Simple extension of the ContextAwareActor class which requires the delegate (Endpoint, Mock-up, etc.) to be
     * supplied as a constructor argument, thus providing model layer management capabilities. Delegate's type is a
     * generic object. This class is to be extended if a specific service's type required.
     *
     * Designed for extension by subclasses.
     *
     * @author jdanilov
     * */
    public class Proxy
            extends ContextAwareActor
    {
        private var _delegate : Object;


        /** Proxy's data service abstraction. */
        protected function get delegate () : Object
        {
            return _delegate;
        }



        /**
         * Creates new Proxy for a given model provider. Automatically registers itself in the context.
         *
         * @param context - context to be used by the controller.
         * @param delegate - data source (service / mockup) to be used by the controller.
         * */
        public function Proxy
                (context : IContext, delegate : Object)
        {
            super(context);
            this._delegate = delegate;
        }
    }
}